import 'dart:async';
import 'dart:ui' show DartPluginRegistrant, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';

import '../l10n/ui_text.dart';
import 'format.dart';
import 'glance.dart';
import 'milestone_alerts.dart';
import 'milestones.dart';
import 'reflection_alerts.dart';
import 'step_math.dart';
import 'store.dart';
import 'voice.dart';

@pragma('vm:entry-point')
void stepTaskCallback() {
  FlutterForegroundTask.setTaskHandler(StepTaskHandler());
}

class StepTaskHandler extends TaskHandler {
  static const String resetTodayCommand = 'resetToday';
  static const String reloadPrefsCommand = 'reloadPrefs';

  StreamSubscription<StepCount>? _sub;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    DartPluginRegistrant.ensureInitialized();
    await Store.instance.init();
    await rollOverIfNewDay(Store.instance);
    await MilestoneAlerts.instance.init();
    await ReflectionAlerts.instance.init();
    await Voice.instance.prepare();
    _listen();
  }

  void _listen() {
    _sub?.cancel();
    try {
      _sub = Pedometer.stepCountStream.listen(
        (event) async {
          final store = Store.instance;
          final previous = store.todaySteps;
          final steps = await applyRawSteps(store, event.steps);
          await FlutterForegroundTask.updateService(
            notificationTitle: uiLine(_lang(), 'appName'),
            notificationText: _notice(steps),
          );
          FlutterForegroundTask.sendDataToMain(steps);
          scheduleQuietStepsWidgetPush();
          await MilestoneAlerts.instance.onStepsUpdated(
            store,
            previous,
            steps,
          );
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    unawaited(_onRepeat());
  }

  Future<void> _onRepeat() async {
    try {
      await Store.instance.reload();
      final rolled = await rollOverIfNewDay(Store.instance);
      final steps = Store.instance.todaySteps;
      await FlutterForegroundTask.updateService(
        notificationTitle: uiLine(_lang(), 'appName'),
        notificationText: _notice(steps),
      );
      FlutterForegroundTask.sendDataToMain(steps);
      scheduleQuietStepsWidgetPush(force: rolled);
      unawaited(ReflectionAlerts.instance.maybeFire(Store.instance));
    } catch (e, st) {
      debugPrint('step_task_repeat_failed:$e\n$st');
    }
  }

  @override
  void onReceiveData(Object data) {
    if (data == resetTodayCommand) {
      unawaited(_resetToday());
    } else if (data == reloadPrefsCommand) {
      unawaited(Store.instance.reload());
    }
  }

  Future<void> _resetToday() async {
    await Store.instance.reload();
    resetTodayCount(Store.instance);
    final steps = Store.instance.todaySteps;
    await FlutterForegroundTask.updateService(
      notificationTitle: uiLine(_lang(), 'appName'),
      notificationText: _notice(steps),
    );
    FlutterForegroundTask.sendDataToMain(steps);
    scheduleQuietStepsWidgetPush(force: true);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _sub?.cancel();
  }

  String _lang() {
    return resolveLanguage(
      stored: Store.instance.language,
      deviceLanguageCode: PlatformDispatcher.instance.locale.languageCode,
    );
  }

  String _notice(int steps) {
    final lang = _lang();
    return uiFill(lang, 'fgStepsToday', n: formatCount(steps, lang));
  }
}
