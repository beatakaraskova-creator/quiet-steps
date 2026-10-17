import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../l10n/ui_text.dart';
import 'milestones.dart';
import 'reflection_alerts.dart';
import 'step_math.dart';
import 'store.dart';
import 'voice.dart';

/// Shows a gentle milestone notification and optionally speaks it.
/// Safe to call from the background step-task isolate.
class MilestoneAlerts {
  MilestoneAlerts._();
  static final MilestoneAlerts instance = MilestoneAlerts._();

  static const _channelId = 'quiet_steps_milestones';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _inited = false;

  /// Last heartbeat from the app screen (set in the background task isolate).
  DateTime? uiSeenAt;

  /// Whether the app screen is open right now. In the app isolate
  /// [AppPresence] replaces this with the real lifecycle state; in the
  /// background task it follows the heartbeats sent by the app.
  bool Function() uiInForeground = _noScreen;

  /// Speaks a line. Swappable in tests.
  Future<void> Function({
    required String text,
    required String language,
    required String speed,
    required String style,
    required String voiceKind,
  }) speak = _speakWithVoice;

  static bool _noScreen() => false;

  static Future<void> _speakWithVoice({
    required String text,
    required String language,
    required String speed,
    required String style,
    required String voiceKind,
  }) =>
      Voice.instance.speak(
        text: text,
        language: language,
        speed: speed,
        style: style,
        voiceKind: voiceKind,
      );

  /// Heartbeat handling in the background task.
  void onUiCommand(Object data, {DateTime? now, Duration timeout = const Duration(seconds: 40)}) {
    if (data == 'uiForeground') {
      uiSeenAt = now ?? DateTime.now();
      uiInForeground = () {
        final seen = uiSeenAt;
        return seen != null && DateTime.now().difference(seen) <= timeout;
      };
    } else if (data == 'uiBackground') {
      uiSeenAt = null;
      uiInForeground = _noScreen;
    }
  }

  String _copyLang() {
    try {
      return resolveLanguage(
        stored: Store.instance.language,
        deviceLanguageCode: PlatformDispatcher.instance.locale.languageCode,
      );
    } catch (_) {
      return 'en';
    }
  }

  Future<void> init() async {
    if (_inited) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        const InitializationSettings(android: android),
        onDidReceiveNotificationResponse: (response) {
          if (response.payload == ReflectionAlerts.payload) {
            openReflectionScreen();
          }
        },
      );
      final lang = _copyLang();
      final channel = AndroidNotificationChannel(
        _channelId,
        uiLine(lang, 'milestoneChannel'),
        description: uiLine(lang, 'milestoneChannelDesc'),
        importance: Importance.low,
        playSound: false,
        showBadge: false,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      _inited = true;
    } catch (_) {}
  }

  /// Returns the milestone ids that fired (empty when none).
  /// When the app screen is open the notification is still posted, but the
  /// voice is left to the app (pop-up: tune, then voice), so nothing is
  /// spoken twice.
  Future<List<String>> onStepsUpdated(
    Store store,
    int previous,
    int current,
  ) async {
    if (!store.milestoneMessages) return const [];
    if (current <= previous) return const [];

    final date = store.todayDate.isEmpty ? todayKey() : store.todayDate;
    final fired = firedKeysForDate(store.firedMilestonesRaw, date);
    final keys = newlyCrossedMilestones(
      previousSteps: previous,
      currentSteps: current,
      goal: store.goal,
      alreadyFired: fired,
    );
    if (keys.isEmpty) return const [];

    final language = resolveLanguage(
      stored: store.language,
      deviceLanguageCode:
          PlatformDispatcher.instance.locale.languageCode,
    );
    final style = store.milestoneStyle;
    final quiet = store.quietHours &&
        inQuietHours(
          start: store.quietStart,
          end: store.quietEnd,
          now: DateTime.now(),
        );

    var screenOpen = false;
    try {
      screenOpen = uiInForeground();
    } catch (_) {}

    await init();

    final day = DateTime.tryParse(date) ?? DateTime.now();
    for (final key in keys) {
      final offset = sameBucketFiredToday(fired, key);
      fired.add(key);
      store.firedMilestonesRaw = encodeFired(date, fired);
      final line = pickMilestoneLine(
        language: language,
        style: style,
        milestone: key,
        day: day,
        offset: offset,
      );
      if (line.isEmpty) continue;
      await store.recordMilestone(
        date: date,
        key: key,
        line: line,
        language: language,
        live: screenOpen,
      );
      await _show(line, key, silent: quiet || screenOpen);
      if (!quiet && !screenOpen && store.speakMessages) {
        try {
          await speak(
            text: line,
            language: language,
            speed: store.voiceSpeed,
            style: style,
            voiceKind: store.voiceKind,
          );
        } catch (_) {}
      }
    }
    return keys;
  }

  Future<void> _show(String line, String key, {required bool silent}) async {
    if (!_inited) return;
    try {
      final id = key == 'goal' ? 8001 : int.tryParse(key) ?? 8000;
      await _plugin.show(
        id,
        uiLine(_copyLang(), 'appName'),
        line,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            uiLine(_copyLang(), 'milestoneChannel'),
            channelDescription: uiLine(_copyLang(), 'milestoneChannelDesc'),
            importance: Importance.low,
            priority: Priority.low,
            playSound: !silent,
            enableVibration: false,
            silent: silent,
            icon: '@mipmap/ic_launcher',
            styleInformation: BigTextStyleInformation(line),
          ),
        ),
      );
    } catch (_) {}
  }

}
