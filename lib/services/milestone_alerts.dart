import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../l10n/ui_text.dart';
import 'milestones.dart';
import 'reflection_alerts.dart';
import 'step_math.dart';
import 'store.dart';

/// Shows a gentle milestone notification and optionally speaks it.
/// Safe to call from the background step-task isolate.
class MilestoneAlerts {
  MilestoneAlerts._();
  static final MilestoneAlerts instance = MilestoneAlerts._();

  static const _channelId = 'quiet_steps_milestones';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  FlutterTts? _tts;
  bool _inited = false;

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

  Future<void> onStepsUpdated(
    Store store,
    int previous,
    int current,
  ) async {
    if (!store.milestoneMessages) return;
    if (current <= previous) return;

    final date = store.todayDate.isEmpty ? todayKey() : store.todayDate;
    final fired = firedKeysForDate(store.firedMilestonesRaw, date);
    final keys = newlyCrossedMilestones(
      previousSteps: previous,
      currentSteps: current,
      goal: store.goal,
      alreadyFired: fired,
    );
    if (keys.isEmpty) return;

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

    await init();

    for (final key in keys) {
      fired.add(key);
      store.firedMilestonesRaw = encodeFired(date, fired);
      final line = pickMilestoneLine(
        language: language,
        style: style,
        milestone: key,
      );
      if (line.isEmpty) continue;
      await _show(line, key, silent: quiet);
      if (!quiet && store.speakMessages) {
        await _speak(line, language, store.voiceSpeed);
      }
    }
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

  Future<void> _speak(String line, String language, String speed) async {
    try {
      _tts ??= FlutterTts();
      final locale = ttsLocales[language] ?? 'en-US';
      var ok = _langOk(await _tts!.isLanguageAvailable(locale));
      if (ok) {
        await _tts!.setLanguage(locale);
      } else {
        ok = _langOk(await _tts!.isLanguageAvailable(language));
        if (!ok) return;
        await _tts!.setLanguage(language);
      }
      await _tts!.setSpeechRate(speed == 'slow' ? 0.35 : 0.5);
      await _tts!.speak(line);
    } catch (_) {
      // No voice for this language, or TTS is unavailable. Text stays.
    }
  }

  bool _langOk(dynamic value) {
    if (value == true || value == 1 || value == 1.0) return true;
    if (value is String) {
      final v = value.toLowerCase();
      return v == 'true' || v == '1';
    }
    return false;
  }
}
