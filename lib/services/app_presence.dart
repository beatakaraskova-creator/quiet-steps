import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'milestone_alerts.dart';

/// Tells the background step task whether the app screen is open, so a
/// milestone is spoken once: by the app when it is open, by the task otherwise.
class AppPresence with WidgetsBindingObserver {
  AppPresence._();
  static final AppPresence instance = AppPresence._();

  static const foregroundCommand = 'uiForeground';
  static const backgroundCommand = 'uiBackground';

  /// The task treats the app as open for this long after the last heartbeat.
  static const heartbeatTimeout = Duration(seconds: 40);
  static const _heartbeat = Duration(seconds: 15);

  bool _started = false;
  bool resumed = true;
  Timer? _timer;

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    final state = WidgetsBinding.instance.lifecycleState;
    resumed = state == null || state == AppLifecycleState.resumed;
    MilestoneAlerts.instance.uiInForeground = () => resumed;
    _apply();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final now = state == AppLifecycleState.resumed;
    if (now == resumed) return;
    resumed = now;
    _apply();
  }

  void _apply() {
    _timer?.cancel();
    _timer = null;
    if (resumed) {
      _send(foregroundCommand);
      _timer = Timer.periodic(_heartbeat, (_) => _send(foregroundCommand));
    } else {
      _send(backgroundCommand);
    }
  }

  void _send(String command) {
    try {
      FlutterForegroundTask.sendDataToTask(command);
    } catch (_) {}
  }
}
