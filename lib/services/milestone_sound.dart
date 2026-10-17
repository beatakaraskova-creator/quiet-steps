import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'milestone_moments.dart';
import 'milestones.dart';
import 'store.dart';
import 'voice.dart';

/// Bundled original tune, about 7 s, played once. Never looped.
const milestoneChimeAsset = 'assets/sounds/milestone_chime.ogg';

/// Phone ringer state. Do Not Disturb counts as silent.
enum PhoneSoundMode { normal, vibrate, silent, unknown }

class SoundPlan {
  const SoundPlan({required this.chime, required this.voice});
  final bool chime;
  final bool voice;
  bool get any => chime || voice;
}

/// What the app plays when the pop-up opens.
/// Quiet hours and a silent, vibrating or Do Not Disturb phone mute everything.
/// The voice only plays for a live moment (the background task stayed quiet).
SoundPlan milestoneSoundPlan({
  required bool live,
  required bool tuneOn,
  required bool speakOn,
  required bool quiet,
  required PhoneSoundMode mode,
}) {
  final muted = quiet ||
      mode == PhoneSoundMode.silent ||
      mode == PhoneSoundMode.vibrate;
  if (muted) return const SoundPlan(chime: false, voice: false);
  return SoundPlan(chime: tuneOn, voice: live && speakOn);
}

const _modeChannel = MethodChannel('quiet_steps/sound_mode');

/// Reads the Android ringer mode. Unknown (other platforms, tests) plays normally.
Future<PhoneSoundMode> readPhoneSoundMode() async {
  try {
    final v = await _modeChannel.invokeMethod<String>('mode');
    switch (v) {
      case 'normal':
        return PhoneSoundMode.normal;
      case 'vibrate':
        return PhoneSoundMode.vibrate;
      case 'silent':
      case 'dnd':
        return PhoneSoundMode.silent;
    }
  } catch (_) {}
  return PhoneSoundMode.unknown;
}

/// The tune player. Swappable in tests.
abstract class ChimeOutput {
  /// Plays the tune once; completes when it ends or is stopped.
  Future<void> play();
  Future<void> duck();
  Future<void> stop();
}

class AssetChime implements ChimeOutput {
  AudioPlayer? _player;

  @override
  Future<void> play() async {
    try {
      final p = _player ??= AudioPlayer();
      await p.stop();
      await p.setLoopMode(LoopMode.off);
      await p.setAsset(milestoneChimeAsset);
      await p.setVolume(0.8);
      await p.play();
    } catch (e, st) {
      debugPrint('milestone_chime_failed:$e\n$st');
    }
  }

  @override
  Future<void> duck() async {
    try {
      await _player?.setVolume(0.35);
    } catch (_) {}
  }

  @override
  Future<void> stop() async {
    try {
      await _player?.stop();
    } catch (_) {}
  }
}

/// Plays the tune, then the voice about 2.5 s in, from the app screen only.
class MilestoneSound {
  MilestoneSound._();
  static final MilestoneSound instance = MilestoneSound._();

  Future<PhoneSoundMode> Function() readMode = readPhoneSoundMode;
  ChimeOutput chime = AssetChime();
  Duration voiceDelay = const Duration(milliseconds: 2500);

  Future<void> Function(MilestoneMoment moment, Store store) speak =
      (moment, store) => Voice.instance.speak(
            text: moment.line,
            language: moment.language,
            speed: store.voiceSpeed,
            style: store.milestoneStyle,
            voiceKind: store.voiceKind,
          );
  Future<void> Function() stopVoice = () => Voice.instance.stop();

  /// Ask other apps to duck (true) or give the audio back (false).
  Future<void> Function(bool hold) focus = _focus;

  int _run = 0;

  Future<SoundPlan> playFor(
    MilestoneMoment moment,
    Store store, {
    DateTime? now,
  }) async {
    final run = ++_run;
    final quiet = store.quietHours &&
        inQuietHours(
          start: store.quietStart,
          end: store.quietEnd,
          now: now ?? DateTime.now(),
        );
    var mode = PhoneSoundMode.unknown;
    try {
      mode = await readMode();
    } catch (_) {}
    final plan = milestoneSoundPlan(
      live: moment.live,
      tuneOn: store.milestoneTune,
      speakOn: store.speakMessages,
      quiet: quiet,
      mode: mode,
    );
    if (!plan.any || run != _run) return plan;

    await _safe(() => focus(true));
    final jobs = <Future<void>>[];
    if (plan.chime) jobs.add(_safe(chime.play));
    if (plan.voice) {
      jobs.add(() async {
        if (plan.chime) await Future<void>.delayed(voiceDelay);
        if (run != _run) return;
        if (plan.chime) await _safe(chime.duck);
        await _safe(() => speak(moment, store));
      }());
    }
    await Future.wait(jobs).timeout(
      const Duration(seconds: 45),
      onTimeout: () => const [],
    );
    if (run == _run) await _safe(() => focus(false));
    return plan;
  }

  /// Stop the tune and the voice (pop-up closed or app left).
  Future<void> stop() async {
    _run++;
    await _safe(chime.stop);
    await _safe(stopVoice);
    await _safe(() => focus(false));
  }

  static Future<void> _safe(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e) {
      debugPrint('milestone_sound:$e');
    }
  }

  static Future<void> _focus(bool hold) async {
    await Voice.instance.prepare();
    final session = await AudioSession.instance;
    await session.setActive(hold);
  }
}
