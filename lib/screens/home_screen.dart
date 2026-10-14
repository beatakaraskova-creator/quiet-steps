import 'dart:async';
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import '../l10n/streak_text.dart';
import '../l10n/walk_text.dart';
import '../services/glance.dart';
import '../services/postcard.dart';
import '../services/look.dart';
import '../services/milestones.dart';
import '../services/reflection.dart';
import '../services/reflection_alerts.dart';
import '../services/step_engine.dart';
import '../services/step_math.dart';
import '../services/store.dart';
import '../services/walks.dart';
import '../widgets/glass_panel.dart';
import '../widgets/step_ring.dart';
import '../widgets/week_strip.dart';
import 'history_screen.dart';
import 'look_screen.dart';
import 'reflection_screen.dart';
import 'settings_screen.dart';
import 'postcard_screen.dart';
import 'walk_journal_screen.dart';
import 'walk_summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final engine = StepEngine.instance;
  Timer? _walkTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    engine.addListener(_tick);
    if (Store.instance.walkActive) _ensureWalkTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    engine.removeListener(_tick);
    _stopWalkTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      engine.refreshFromDisk();
      ReflectionAlerts.instance.maybeFire(Store.instance);
    }
  }

  void _tick() {
    if (mounted) setState(() {});
  }

  String _language() {
    return resolveLanguage(
      stored: Store.instance.language,
      deviceLanguageCode: PlatformDispatcher.instance.locale.languageCode,
    );
  }

  void _ensureWalkTimer() {
    _walkTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (Store.instance.walkActive) {
        setState(() {});
      } else {
        _stopWalkTimer();
      }
    });
  }

  void _stopWalkTimer() {
    _walkTimer?.cancel();
    _walkTimer = null;
  }

  Future<void> _chooseMood() async {
    final look = Look.instance.pack;
    final lang = _language();
    final mood = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: look.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Text(
                    walkUiLine(lang, 'choose'),
                    style: TextStyle(
                      color: look.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                for (final id in walkMoodIds)
                  ListTile(
                    title: Text(
                      walkMoodLabel(lang, id),
                      style: TextStyle(color: look.ink),
                    ),
                    onTap: () => Navigator.pop(ctx, id),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (mood == null || !mounted) return;
    Store.instance.startWalk(mood, Store.instance.todaySteps, DateTime.now());
    _ensureWalkTimer();
    setState(() {});
  }

  Future<void> _endWalk() async {
    final store = Store.instance;
    if (!store.walkActive) return;
    final lang = _language();
    final end = DateTime.now();
    final start = DateTime.fromMillisecondsSinceEpoch(store.walkStartMs);
    final entry = finishWalk(
      mood: store.walkMood,
      startSteps: store.walkStartSteps,
      currentSteps: store.todaySteps,
      start: start,
      end: end,
    );
    final line = pickWalkLine(language: lang, mood: entry.mood);
    store.clearWalk();
    _stopWalkTimer();
    if (!mounted) return;
    setState(() {});
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WalkSummaryScreen(
          entry: entry,
          line: line,
          language: lang,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Store.instance;
    final look = Look.instance.pack;
    final scale = Look.instance.fontScale;
    final steps = store.todaySteps;
    final goal = store.goal;
    final lang = _language();

    final photo = Look.instance.backgroundPath;
    final photoFile = photo != null ? File(photo) : null;
    final hasPhoto = photoFile != null && photoFile.existsSync();

    return Container(
      key: ValueKey(Look.instance.photoTick),
      decoration: BoxDecoration(
        color: look.bg,
        image: hasPhoto
            ? DecorationImage(
                image: FileImage(photoFile),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'QUIET STEPS',
          style: TextStyle(
            fontSize: 13 * scale,
            letterSpacing: 1.6,
            color: look.muted,
            fontWeight: FontWeight.w600,
            shadows: _photoShadow(hasPhoto),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Look',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LookScreen()),
              );
              scheduleQuietStepsWidgetPush(force: true);
              setState(() {});
            },
            icon: Icon(Icons.palette_outlined, color: look.muted),
          ),
          IconButton(
            tooltip: 'History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
            icon: Icon(Icons.calendar_today_outlined, color: look.muted),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              scheduleQuietStepsWidgetPush(force: true);
              setState(() {});
            },
            icon: Icon(Icons.tune, color: look.muted),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            const SizedBox(height: 12),
            Center(
              child: StepRing(
                steps: steps,
                goal: goal,
                track: hasPhoto
                    ? look.ink.withValues(alpha: 0.28)
                    : look.line,
                accent: look.accent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _fmt(steps),
                      style: TextStyle(
                        fontSize: 52 * scale,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        letterSpacing: -1.5,
                        color: look.ink,
                        shadows: _photoShadow(hasPhoto, strong: true),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'of ${_fmt(goal)} today',
                      style: TextStyle(
                        color: look.muted,
                        shadows: _photoShadow(hasPhoto),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            WeekStrip(
              stepsByDate: _stepsByDate(store),
              goal: goal,
              now: DateTime.now(),
              language: lang,
              pack: look,
              fontScale: scale,
              frosted: hasPhoto,
            ),
            if (store.eveningReflection &&
                isAfterReflectionTime(
                  timeHm: store.reflectionTime,
                  now: DateTime.now(),
                )) ...[
              const SizedBox(height: 12),
              _reflectionCard(
                language: lang,
                photo: hasPhoto,
              ),
            ],
            const SizedBox(height: 22),
            Row(
              children: [
                _stat(
                  store.kmToday.toStringAsFixed(2),
                  'km',
                  photo: hasPhoto,
                ),
                const SizedBox(width: 10),
                _stat(
                  '${store.kcalToday}',
                  'kcal',
                  photo: hasPhoto,
                ),
                const SizedBox(width: 10),
                _stat(
                  '${goal <= 0 ? 0 : ((steps / goal) * 100).clamp(0, 999).round()}%',
                  'goal',
                  photo: hasPhoto,
                ),
              ],
            ),
            const SizedBox(height: 22),
            if (engine.permissionDenied)
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Physical activity permission is needed so the phone can count steps. Location is not used.',
                  style: TextStyle(color: look.muted, height: 1.4),
                ),
              ),
            if (engine.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  engine.error!,
                  style: TextStyle(color: look.muted, height: 1.4),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: engine.counting ? engine.stop : engine.start,
                    style: FilledButton.styleFrom(
                      backgroundColor: engine.counting
                          ? look.card.withValues(alpha: hasPhoto ? 0.45 : 1)
                          : look.accent,
                      foregroundColor:
                          engine.counting ? look.ink : look.onAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: engine.counting
                            ? BorderSide(
                                color: hasPhoto
                                    ? look.ink.withValues(alpha: 0.28)
                                    : look.line,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: Text(engine.counting ? 'Pause counting' : 'Start counting'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (store.walkActive)
              _walkLiveCard(
                language: lang,
                photo: hasPhoto,
                stepsNow: steps,
              )
            else
              OutlinedButton(
                onPressed: _chooseMood,
                style: OutlinedButton.styleFrom(
                  foregroundColor: look.ink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 52),
                  side: BorderSide(
                    color: hasPhoto
                        ? look.ink.withValues(alpha: 0.28)
                        : look.line,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(walkUiLine(lang, 'start')),
              ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: look.card,
                    title: const Text('Reset today?'),
                    content: const Text(
                      'Today’s count goes back to zero. History stays.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Keep'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
                if (ok == true) engine.resetToday();
              },
              child: Text(
                'Reset today',
                style: TextStyle(
                  color: look.muted,
                  shadows: _photoShadow(hasPhoto),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WalkJournalScreen(),
                        ),
                      );
                      if (mounted) setState(() {});
                    },
                    child: Text(
                      walkUiLine(lang, 'journal'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: look.muted,
                        shadows: _photoShadow(hasPhoto),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PostcardScreen(),
                        ),
                      );
                    },
                    child: Text(
                      postcardUiLine(lang, 'title'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: look.muted,
                        shadows: _photoShadow(hasPhoto),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GlassPanel(
              frosted: hasPhoto,
              color: look.card,
              light: look.light,
              radius: 16,
              padding: const EdgeInsets.all(16),
              child: Text(
                engine.counting
                    ? 'Counting in the background. Keep the notification on. No GPS. No internet. Data stays on this phone.'
                    : 'Tap Start. Walk with the phone on you. You can leave the app — the notification means it is still counting.',
                style: TextStyle(
                  color: look.muted,
                  height: 1.45,
                  fontSize: 13.5 * scale,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  List<Shadow>? _photoShadow(bool photo, {bool strong = false}) {
    if (!photo) return null;
    return [
      Shadow(
        blurRadius: strong ? 16 : 10,
        color: Colors.black.withValues(alpha: strong ? 0.55 : 0.40),
      ),
    ];
  }

  Widget _walkLiveCard({
    required String language,
    required bool photo,
    required int stepsNow,
  }) {
    final pack = Look.instance.pack;
    final store = Store.instance;
    final start = DateTime.fromMillisecondsSinceEpoch(store.walkStartMs);
    final minutes = walkMinutes(start, DateTime.now());
    final walkSteps = walkStepDifference(store.walkStartSteps, stepsNow);
    return GlassPanel(
      frosted: photo,
      color: pack.card,
      light: pack.light,
      radius: 16,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            walkMoodLabel(language, store.walkMood),
            style: TextStyle(
              color: pack.ink,
              fontSize: 16 * Look.instance.fontScale,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${walkMinutesLabel(language, minutes)}  ·  ${StreakText.steps(language, walkSteps)}',
            style: TextStyle(color: pack.accent, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _endWalk,
            style: OutlinedButton.styleFrom(
              foregroundColor: pack.ink,
              side: BorderSide(color: pack.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(walkUiLine(language, 'end')),
          ),
        ],
      ),
    );
  }

  Widget _reflectionCard({required String language, required bool photo}) {
    final pack = Look.instance.pack;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReflectionScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: GlassPanel(
          frosted: photo,
          color: pack.card,
          light: pack.light,
          radius: 16,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Icon(
                Icons.nightlight_round,
                color: pack.accent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  reflectionUiLine(language, 'card'),
                  style: TextStyle(
                    color: pack.ink,
                    fontSize: 15 * Look.instance.fontScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: pack.muted),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> _stepsByDate(Store store) {
    final map = <String, int>{
      for (final d in store.history()) d.date: d.steps,
    };
    final key = store.todayDate.isEmpty ? todayKey() : store.todayDate;
    map[key] = store.todaySteps;
    return map;
  }

  Widget _stat(String value, String label, {required bool photo}) {
    final pack = Look.instance.pack;
    return Expanded(
      child: GlassPanel(
        frosted: photo,
        color: pack.card,
        light: pack.light,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18 * Look.instance.fontScale,
                fontWeight: FontWeight.w600,
                color: pack.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: pack.muted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
