import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';

import 'milestone_alerts.dart';
import 'step_math.dart';
import 'store.dart';

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
    await Store.instance.init();
    await MilestoneAlerts.instance.init();
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
            notificationTitle: 'Quiet Steps',
            notificationText: '${_fmt(steps)} steps today · on this phone only',
          );
          FlutterForegroundTask.sendDataToMain(steps);
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
    final steps = Store.instance.todaySteps;
    FlutterForegroundTask.updateService(
      notificationTitle: 'Quiet Steps',
      notificationText: '${_fmt(steps)} steps today · on this phone only',
    );
    FlutterForegroundTask.sendDataToMain(steps);
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
      notificationTitle: 'Quiet Steps',
      notificationText: '${_fmt(steps)} steps today · on this phone only',
    );
    FlutterForegroundTask.sendDataToMain(steps);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _sub?.cancel();
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
