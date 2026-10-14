import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'step_math.dart';
import 'step_task.dart';
import 'store.dart';

class StepEngine extends ChangeNotifier {
  StepEngine._();
  static final StepEngine instance = StepEngine._();

  StreamSubscription<StepCount>? _fgSub;
  String? error;
  bool permissionDenied = false;
  bool ready = false;

  int get steps => Store.instance.todaySteps;
  bool get counting => Store.instance.counting;

  Future<void> init() async {
    await Store.instance.init();
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'quiet_steps',
        channelName: 'Quiet Steps',
        channelDescription: 'Step counting on this phone. Nothing is sent.',
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
    _listenForeground();
    if (Store.instance.counting) {
      await start();
    }
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
      error = 'Allow notifications so counting can stay on in the pocket.';
    }
    notifyListeners();
    return true;
  }

  void _listenForeground() {
    _fgSub?.cancel();
    try {
      _fgSub = Pedometer.stepCountStream.listen(
        (event) async {
          await applyRawSteps(Store.instance, event.steps);
          error = null;
          notifyListeners();
        },
        onError: (e) {
          error =
              'This phone did not give a step sensor. Some models need a short walk first.';
          notifyListeners();
        },
      );
    } catch (e) {
      error = 'Step sensor is not available on this device.';
      notifyListeners();
    }
  }

  Future<void> start() async {
    final ok = await requestPermission();
    if (!ok) return;

    Store.instance.counting = true;
    _listenForeground();

    if (await FlutterForegroundTask.isRunningService) {
      notifyListeners();
      return;
    }

    await FlutterForegroundTask.startService(
      serviceId: 3101,
      notificationTitle: 'Quiet Steps',
      notificationText: 'Counting steps on this phone only',
      callback: stepTaskCallback,
      serviceTypes: [ForegroundServiceTypes.health],
    );
    notifyListeners();
  }

  Future<void> stop() async {
    Store.instance.counting = false;
    await FlutterForegroundTask.stopService();
    notifyListeners();
  }

  Future<void> resetToday() async {
    // Next raw reading becomes the new zero for today.
    Store.instance.todayOffset = Store.instance.lastRaw;
    Store.instance.todaySteps = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _fgSub?.cancel();
    super.dispose();
  }
}
