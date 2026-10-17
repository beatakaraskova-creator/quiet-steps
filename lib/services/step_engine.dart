import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/ui_text.dart';
import 'app_locale.dart';
import 'glance.dart';
import 'milestone_alerts.dart';
import 'step_math.dart';
import 'step_task.dart';
import 'store.dart';
import 'voice.dart';

class StepEngine extends ChangeNotifier {
  StepEngine._();
  static final StepEngine instance = StepEngine._();

  StreamSubscription<StepCount>? _fgSub;
  String? errorKey;
  bool permissionDenied = false;

  String? get error {
    final key = errorKey;
    if (key == null) return null;
    return uiLine(currentLanguage(), key);
  }
  bool ready = false;
  bool _serviceOwnsWrites = false;
  bool _listeningTaskData = false;

  int get steps => Store.instance.todaySteps;
  bool get counting => Store.instance.counting;

  Future<void> init() async {
    await Store.instance.init();
    await rollOverIfNewDay(Store.instance);
    unawaited(Voice.instance.prepare());
    AppLocale.instance.load();
    FlutterForegroundTask.initCommunicationPort();
    if (!_listeningTaskData) {
      FlutterForegroundTask.addTaskDataCallback(_onTaskData);
      _listeningTaskData = true;
    }
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'quiet_steps',
        channelName: uiLine(currentLanguage(), 'fgChannelName'),
        channelDescription: uiLine(currentLanguage(), 'fgChannelDesc'),
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(20000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
    ready = true;
    notifyListeners();
    if (Store.instance.counting) {
      await start();
    } else {
      _listenForeground();
    }
  }

  Future<void> refreshFromDisk() async {
    await Store.instance.reload();
    final rolled = await rollOverIfNewDay(Store.instance);
    if (rolled) {
      scheduleQuietStepsWidgetPush(force: true);
    }
    notifyListeners();
  }

  void _onTaskData(Object data) {
    unawaited(refreshFromDisk());
  }

  Future<bool> requestPermission() async {
    final activity = await Permission.activityRecognition.request();
    final notif = await Permission.notification.request();
    if (activity.isDenied || activity.isPermanentlyDenied) {
      permissionDenied = true;
      notifyListeners();
      return false;
    }
    permissionDenied = false;
    // Notification is optional-ish but needed for the background bar.
    if (notif.isPermanentlyDenied) {
      errorKey = 'needNotifications';
    }
    notifyListeners();
    return true;
  }

  void _listenForeground() {
    _fgSub?.cancel();
    try {
      _fgSub = Pedometer.stepCountStream.listen(
        (event) async {
          if (!Store.instance.counting) {
            return;
          }
          if (_serviceOwnsWrites ||
              await FlutterForegroundTask.isRunningService) {
            return;
          }
          final previous = Store.instance.todaySteps;
          final steps = await applyRawSteps(Store.instance, event.steps);
          await MilestoneAlerts.instance.onStepsUpdated(
            Store.instance,
            previous,
            steps,
          );
          scheduleQuietStepsWidgetPush();
          errorKey = null;
          notifyListeners();
        },
        onError: (e) {
          errorKey = 'noSensorWalk';
          notifyListeners();
        },
      );
    } catch (e) {
      errorKey = 'noSensor';
      notifyListeners();
    }
  }

  Future<void> start() async {
    final ok = await requestPermission();
    if (!ok) {
      _serviceOwnsWrites = false;
      errorKey = 'needActivity';
      _listenForeground();
      notifyListeners();
      return;
    }

    Store.instance.counting = true;
    await _fgSub?.cancel();
    _fgSub = null;

    if (await FlutterForegroundTask.isRunningService) {
      _serviceOwnsWrites = true;
      notifyListeners();
      return;
    }

    _serviceOwnsWrites = true;
    final result = await FlutterForegroundTask.startService(
      serviceId: 3101,
      notificationTitle: uiLine(currentLanguage(), 'appName'),
      notificationText: uiLine(currentLanguage(), 'fgCounting'),
      callback: stepTaskCallback,
      serviceTypes: [ForegroundServiceTypes.health],
    );
    if (result is ServiceRequestFailure) {
      _serviceOwnsWrites = false;
      errorKey = 'bgFailed';
      _listenForeground();
      notifyListeners();
      return;
    }

    notifyListeners();
  }

  Future<void> stop() async {
    Store.instance.counting = false;
    Store.instance.skipPausedGap = true;
    _serviceOwnsWrites = false;
    await FlutterForegroundTask.stopService();
    _listenForeground();
    notifyListeners();
  }

  void syncTaskPrefs() {
    FlutterForegroundTask.sendDataToTask(StepTaskHandler.reloadPrefsCommand);
  }

  Future<void> resetToday() async {
    if (_serviceOwnsWrites || await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.sendDataToTask(StepTaskHandler.resetTodayCommand);
      return;
    }
    await Store.instance.reload();
    resetTodayCount(Store.instance);
    scheduleQuietStepsWidgetPush(force: true);
    notifyListeners();
  }

  @override
  void dispose() {
    _fgSub?.cancel();
    if (_listeningTaskData) {
      FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
      _listeningTaskData = false;
    }
    super.dispose();
  }
}
