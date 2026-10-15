import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../l10n/spoken_catalog.dart';
import 'milestones.dart';
import 'store.dart';

/// Bundled Piper clips, with the phone TTS engine as fallback.
class Voice {
  Voice._();
  static final Voice instance = Voice._();

  FlutterTts? _tts;
  AudioPlayer? _player;
  bool _sessionReady = false;

  Future<void> speak({
    required String text,
    required String language,
    required String speed,
    String style = 'calm',
    String? voiceKind,
    String? lineId,
  }) async {
    if (text.trim().isEmpty) return;
    final kind = voiceKind ?? Store.instance.voiceKind;
    await stop();
    if (kind != 'phone') {
      final id = lineId ?? spokenIdForText(language, text);
      if (id != null) {
        final asset = voiceClipAsset(language, kind, id);
        final played = await _playClip(asset, speed);
        if (played) return;
      }
    }
    await _speakTts(text, language, speed, style);
  }

  Future<void> playSample({
    required String language,
    required String voiceKind,
    required String speed,
  }) async {
    await speak(
      text: voiceSampleLine(language),
      language: language,
      speed: speed,
      voiceKind: voiceKind,
      lineId: 'voice_sample',
    );
  }

  Future<void> stop() async {
    try {
      await _player?.stop();
    } catch (_) {}
    try {
      await _tts?.stop();
    } catch (_) {}
  }

  Future<bool> _playClip(String asset, String speed) async {
    try {
      await rootBundle.load(asset);
    } catch (_) {
      return false;
    }
    try {
      await _ensureSession();
      _player ??= AudioPlayer();
      await _player!.stop();
      await _player!.setAsset(asset);
      await _player!.setSpeed(speed == 'slow' ? 0.88 : 1.0);
      await _player!.setVolume(1);
      await _player!.play();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _ensureSession() async {
    if (_sessionReady) return;
    try {
      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.duckOthers,
          avAudioSessionMode: AVAudioSessionMode.spokenAudio,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.speech,
            flags: AndroidAudioFlags.none,
            usage: AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType:
              AndroidAudioFocusGainType.gainTransientMayDuck,
          androidWillPauseWhenDucked: false,
        ),
      );
      _sessionReady = true;
    } catch (_) {}
  }

  Future<void> _speakTts(
    String text,
    String language,
    String speed,
    String style,
  ) async {
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

  bool _langOk(dynamic value) {
    if (value == true || value == 1 || value == 1.0) return true;
    if (value is String) {
      final v = value.toLowerCase();
      return v == 'true' || v == '1';
    }
    return false;
  }
}
