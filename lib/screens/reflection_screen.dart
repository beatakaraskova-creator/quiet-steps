import 'package:flutter/material.dart';

import '../services/look.dart';
import '../services/milestones.dart';
import '../services/reflection.dart';
import '../services/step_math.dart';
import '../services/store.dart';
import '../services/voice.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  late final ReflectionCopy _copy;
  late final String _language;
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    final store = Store.instance;
    final now = DateTime.now();
    _language = resolveLanguage(
      stored: store.language,
      deviceLanguageCode:
          WidgetsBinding.instance.platformDispatcher.locale.languageCode,
    );
    _copy = buildReflectionCopy(
      steps: store.todaySteps,
      goal: store.goal,
      stepsByDate: _stepsByDate(store, now),
      now: now,
      language: _language,
    );
    final quiet = store.quietHours &&
        inQuietHours(
          start: store.quietStart,
          end: store.quietEnd,
          now: now,
        );
    if (store.speakMessages && !quiet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _readAloud();
      });
    }
  }

  @override
  void dispose() {
    Voice.instance.stop();
    super.dispose();
  }

  Map<String, int> _stepsByDate(Store store, DateTime now) {
    final map = <String, int>{
      for (final d in store.history()) d.date: d.steps,
    };
    final key = store.todayDate.isEmpty ? todayKey(now) : store.todayDate;
    map[key] = store.todaySteps;
    return map;
  }

  Future<void> _readAloud() async {
    if (_speaking) {
      await Voice.instance.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    setState(() => _speaking = true);
    await Voice.instance.speak(
      text: _copy.spoken,
      language: _language,
      speed: Store.instance.voiceSpeed,
      style: Store.instance.milestoneStyle,
    );
    if (mounted) setState(() => _speaking = false);
  }

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    final scale = Look.instance.fontScale;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        title: Text(reflectionUiLine(_language, 'card')),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        children: [
          Text(
            _copy.summary,
            style: TextStyle(
              color: p.ink,
              fontSize: 22 * scale,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _copy.closing,
            style: TextStyle(
              color: p.ink,
              fontSize: 18 * scale,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _copy.streak,
            style: TextStyle(
              color: p.accent,
              fontSize: 16 * scale,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 36),
          FilledButton(
            onPressed: _readAloud,
            style: FilledButton.styleFrom(
              backgroundColor: p.accent,
              foregroundColor: p.onAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(reflectionUiLine(_language, 'readAloud')),
          ),
        ],
      ),
    );
  }
}
