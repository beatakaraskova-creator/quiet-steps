import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import '../services/look.dart';
import '../services/milestones.dart';
import '../services/reflection.dart';
import '../services/reflection_alerts.dart';
import '../services/step_engine.dart';
import '../services/step_math.dart';
import '../services/store.dart';
import '../widgets/glass_panel.dart';
import '../widgets/step_ring.dart';
import '../widgets/week_strip.dart';
import 'history_screen.dart';
import 'look_screen.dart';
import 'reflection_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final engine = StepEngine.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    engine.addListener(_tick);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    engine.removeListener(_tick);
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
              language: resolveLanguage(
                stored: store.language,
                deviceLanguageCode:
                    PlatformDispatcher.instance.locale.languageCode,
              ),
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
                language: resolveLanguage(
                  stored: store.language,
                  deviceLanguageCode:
                      PlatformDispatcher.instance.locale.languageCode,
                ),
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
