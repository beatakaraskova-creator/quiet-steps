import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../screens/reflection_screen.dart';
import 'milestones.dart';
import 'reflection.dart';
import 'step_math.dart';
import 'store.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

/// Evening reflection notification. Safe from the step-task isolate.
class ReflectionAlerts {
  ReflectionAlerts._();
  static final ReflectionAlerts instance = ReflectionAlerts._();

  static const payload = 'evening_reflection';
  static const notifId = 8100;
  static const _channelId = 'quiet_steps_reflection';
  static const _channelName = 'Evening reflection';
  static const _channelDesc = 'A gentle summary of the day.';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _inited = false;
  bool _tzReady = false;

  Future<void> init() async {
    if (_inited) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        const InitializationSettings(android: android),
        onDidReceiveNotificationResponse: _onTap,
      );
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.low,
        playSound: false,
        showBadge: false,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      _inited = true;
      await _openIfLaunchedFromNotification();
    } catch (_) {}
  }

  Future<void> _openIfLaunchedFromNotification() async {
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp == true &&
          details?.notificationResponse?.payload == payload) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          openReflectionScreen();
        });
      }
    } catch (_) {}
  }

  void _onTap(NotificationResponse response) {
    if (response.payload == payload) {
      openReflectionScreen();
    }
  }

  Future<void> maybeFire(Store store, {DateTime? now}) async {
    if (!store.eveningReflection) return;
    final at = now ?? DateTime.now();
    if (!shouldFireReflection(
      enabled: store.eveningReflection,
      lastFiredDate: store.lastReflectionDate,
      timeHm: store.reflectionTime,
      now: at,
    )) {
      return;
    }
    await init();
    final language = resolveLanguage(
      stored: store.language,
      deviceLanguageCode:
          WidgetsBinding.instance.platformDispatcher.locale.languageCode,
    );
    final silent = reflectionIsSilent(
      quietOn: store.quietHours,
      quietStart: store.quietStart,
      quietEnd: store.quietEnd,
      timeHm: store.reflectionTime,
    );
    final body = reflectionSummaryLine(language, store.todaySteps);
    store.lastReflectionDate = todayKey(at);
    await _show(body, silent: silent);
    await syncSchedule(store);
  }

  Future<void> _show(String body, {required bool silent}) async {
    if (!_inited) return;
    try {
      await _plugin.show(
        notifId,
        'Quiet Steps',
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.low,
            priority: Priority.low,
            playSound: !silent,
            enableVibration: false,
            silent: silent,
            icon: '@mipmap/ic_launcher',
            styleInformation: BigTextStyleInformation(body),
          ),
        ),
        payload: payload,
      );
    } catch (_) {}
  }

  Future<void> syncSchedule(Store store) async {
    await init();
    try {
      await _plugin.cancel(notifId);
    } catch (_) {}
    if (!store.eveningReflection) return;
    try {
      await _ensureTz();
      final silent = reflectionIsSilent(
        quietOn: store.quietHours,
        quietStart: store.quietStart,
        quietEnd: store.quietEnd,
        timeHm: store.reflectionTime,
      );
      final language = resolveLanguage(
        stored: store.language,
        deviceLanguageCode:
            WidgetsBinding.instance.platformDispatcher.locale.languageCode,
      );
      final when = _nextSlot(store.reflectionTime, store.lastReflectionDate);
      final body = reflectionUiLine(language, 'card');
      await _plugin.zonedSchedule(
        notifId,
        'Quiet Steps',
        body,
        when,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.low,
            priority: Priority.low,
            playSound: !silent,
            enableVibration: false,
            silent: silent,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    } catch (_) {}
  }

  Future<void> _ensureTz() async {
    if (_tzReady) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {}
    _tzReady = true;
  }

  tz.TZDateTime _nextSlot(String timeHm, String lastFiredDate) {
    final mins = minutesFromHm(timeHm);
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      mins ~/ 60,
      mins % 60,
    );
    final today = todayKey(DateTime(now.year, now.month, now.day));
    if (!next.isAfter(now) || lastFiredDate == today) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }
}

void openReflectionScreen() {
  final nav = appNavigatorKey.currentState;
  if (nav == null) return;
  if (!Store.instance.onboardingDone) return;
  nav.push(
    MaterialPageRoute(
      settings: const RouteSettings(name: 'reflection'),
      builder: (_) => const ReflectionScreen(),
    ),
  );
}
