import 'package:flutter_tts/flutter_tts.dart';

import 'milestones.dart';

/// Phone TTS. Same language, speed and style as milestone voice.
class Voice {
  Voice._();
  static final Voice instance = Voice._();

  FlutterTts? _tts;

  Future<void> speak({
    required String text,
    required String language,
    required String speed,
    String style = 'calm',
  }) async {
    if (text.trim().isEmpty) return;
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
      await _tts!.setPitch(style == 'cheerful' ? 1.08 : 0.96);
      await _tts!.speak(text);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _tts?.stop();
    } catch (_) {}
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
