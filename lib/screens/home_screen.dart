import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/easy_text.dart';
import '../l10n/glance_text.dart';
import '../l10n/streak_text.dart';
import '../l10n/ui_text.dart';
import '../l10n/walk_text.dart';
import '../models/look_pack.dart';
import '../services/app_locale.dart';
import '../services/easy_mode.dart';
import '../services/format.dart';
import '../services/glance.dart';
import '../services/postcard.dart';
import '../services/look.dart';
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
    Look.instance.addListener(_tick);
    AppLocale.instance.addListener(_tick);
    if (Store.instance.walkActive) _ensureWalkTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    engine.removeListener(_tick);
    Look.instance.removeListener(_tick);
    AppLocale.instance.removeListener(_tick);
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

  String _language() => currentLanguage();

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
      carry: store.walkCarrySteps,
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

  String _fmt(int n) => formatCount(n, _language());

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

    if (Look.instance.bigSimple) {
      return _easyHome(
        store: store,
        look: look,
        scale: scale,
        steps: steps,
        goal: goal,
        lang: lang,
      );
    }

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
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
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
            tooltip: uiLine(lang, 'look'),
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
            tooltip: uiLine(lang, 'history'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
            icon: Icon(Icons.calendar_today_outlined, color: look.muted),
          ),
          IconButton(
            tooltip: uiLine(lang, 'settings'),
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
                      steps >= goal && goal > 0
                          ? glanceGoalReached(lang)
                          : uiFill(lang, 'ofToday', n: _fmt(goal)),
                      key: const ValueKey('home-status'),
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
                  formatDecimal(store.kmToday, lang),
                  uiLine(lang, 'km'),
                  photo: hasPhoto,
                ),
                const SizedBox(width: 10),
                _stat(
                  '${store.kcalToday}',
                  uiLine(lang, 'kcal'),
                  photo: hasPhoto,
                ),
                const SizedBox(width: 10),
                _stat(
                  '${goal <= 0 ? 0 : ((steps / goal) * 100).clamp(0, 999).round()}%',
                  uiLine(lang, 'goalPct'),
                  photo: hasPhoto,
                ),
              ],
            ),
            const SizedBox(height: 22),
            if (engine.permissionDenied)
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  uiLine(lang, 'permissionDenied'),
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
                  child: engine.counting
                      ? OutlinedButton(
                          onPressed: engine.stop,
                          style: secondaryOutlineStyle(look, photo: hasPhoto),
                          child: Text(uiLine(lang, 'pauseCounting')),
                        )
                      : FilledButton(
                          onPressed: engine.start,
                          style: FilledButton.styleFrom(
                            backgroundColor: look.accent,
                            foregroundColor: look.onAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(uiLine(lang, 'startCounting')),
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
                style: secondaryOutlineStyle(
                  look,
                  photo: hasPhoto,
                  minimumSize: const Size(double.infinity, 52),
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
                    title: Text(uiLine(lang, 'resetTodayTitle')),
                    content: Text(uiLine(lang, 'resetTodayBody')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(uiLine(lang, 'keep')),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(uiLine(lang, 'reset')),
                      ),
                    ],
                  ),
                );
                if (ok == true) engine.resetToday();
              },
              child: Text(
                uiLine(lang, 'resetToday'),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                    ? uiLine(lang, 'countingOn')
                    : uiLine(lang, 'countingOff'),
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

  Widget _easyHome({
    required Store store,
    required LookPack look,
    required double scale,
    required int steps,
    required int goal,
    required String lang,
  }) {
    final pack = look;
    final status = glanceDataFromStore(store, deviceLanguage: lang).statusLine;
    return Scaffold(
      key: const ValueKey('easy-home'),
      backgroundColor: pack.bg,
      appBar: AppBar(
        backgroundColor: pack.bg,
        foregroundColor: pack.ink,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          uiLine(lang, 'appName'),
          style: TextStyle(
            fontSize: 18 * scale,
            fontWeight: FontWeight.w600,
            color: pack.ink,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: easyRingSize,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StepRing(
                          steps: steps,
                          goal: goal,
                          track: pack.line,
                          accent: pack.accent,
                          size: easyRingSize,
                          strokeWidth: easyRingStroke,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _fmt(steps),
                                key: const ValueKey('easy-steps'),
                                style: TextStyle(
                                  fontSize: 56 * scale,
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                  color: pack.ink,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: easyRingSize,
                          child: Text(
                            status,
                            key: const ValueKey('easy-status'),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: pack.ink,
                              fontSize: 20 * scale,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (engine.permissionDenied || engine.error != null) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: easyRingSize,
                            child: Text(
                              engine.error ??
                                  uiLine(lang, 'permissionDenied'),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: pack.muted,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (store.walkActive) ...[
                Text(
                  '${walkMoodLabel(lang, store.walkMood)}  ·  ${walkMinutesLabel(lang, walkMinutes(DateTime.fromMillisecondsSinceEpoch(store.walkStartMs), DateTime.now()))}',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: pack.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _easyButton(
                  key: const ValueKey('easy-walk'),
                  label: walkUiLine(lang, 'end'),
                  filled: true,
                  pack: pack,
                  onPressed: _endWalk,
                ),
              ] else
                _easyButton(
                  key: const ValueKey('easy-walk'),
                  label: walkUiLine(lang, 'start'),
                  filled: false,
                  pack: pack,
                  onPressed: _chooseMood,
                ),
              const SizedBox(height: 12),
              _easyButton(
                key: const ValueKey('easy-more'),
                label: easyUiLine(lang, 'more'),
                filled: true,
                pack: pack,
                onPressed: () => _openMore(lang, pack),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _easyButton({
    required Key key,
    required String label,
    required bool filled,
    required LookPack pack,
    required VoidCallback onPressed,
  }) {
    final p = pack;
    final child = Text(
      label,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
    );
    final style = filled
        ? FilledButton.styleFrom(
            backgroundColor: p.accent,
            foregroundColor: p.onAccent,
            minimumSize: const Size(double.infinity, easyTapMin),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          )
        : secondaryOutlineStyle(
            p,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            minimumSize: const Size(double.infinity, easyTapMin),
            radius: 16,
            borderWidth: 2,
          );
    return filled
        ? FilledButton(key: key, onPressed: onPressed, style: style, child: child)
        : OutlinedButton(key: key, onPressed: onPressed, style: style, child: child);
  }

  Future<void> _openMore(String lang, LookPack pack) async {
    final p = pack;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        Widget row(String key, String label, VoidCallback open) {
          return ListTile(
            key: ValueKey('easy-more-$key'),
            minVerticalPadding: 18,
            title: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: p.ink,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: p.muted),
            onTap: () {
              Navigator.pop(ctx);
              open();
            },
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Text(
                      easyUiLine(lang, 'more'),
                      style: TextStyle(
                        color: p.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  row('week', easyUiLine(lang, 'thisWeek'), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const _EasyWeekScreen()),
                    );
                  }),
                  row('reflection', easyUiLine(lang, 'reflection'), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReflectionScreen()),
                    );
                  }),
                  row('journal', easyUiLine(lang, 'journal'), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WalkJournalScreen()),
                    );
                  }),
                  row('postcard', easyUiLine(lang, 'postcard'), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PostcardScreen()),
                    );
                  }),
                  row('settings', easyUiLine(lang, 'settings'), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ).then((_) {
                      scheduleQuietStepsWidgetPush(force: true);
                      if (mounted) setState(() {});
                    });
                  }),
                  row('look', easyUiLine(lang, 'look'), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LookScreen()),
                    ).then((_) {
                      scheduleQuietStepsWidgetPush(force: true);
                      if (mounted) setState(() {});
                    });
                  }),
                  row('history', easyUiLine(lang, 'history'), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  }),
                  row(
                    'counting',
                    engine.counting
                        ? easyUiLine(lang, 'pauseCounting')
                        : easyUiLine(lang, 'startCounting'),
                    () {
                      if (engine.counting) {
                        engine.stop();
                      } else {
                        engine.start();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    final walkSteps = walkStepsNow(
      startSteps: store.walkStartSteps,
      currentSteps: stepsNow,
      carry: store.walkCarrySteps,
    );
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
            style: secondaryOutlineStyle(pack),
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

class _EasyWeekScreen extends StatelessWidget {
  const _EasyWeekScreen();

  @override
  Widget build(BuildContext context) {
    final store = Store.instance;
    final pack = Look.instance.pack;
    final lang = currentLanguage();
    final map = <String, int>{
      for (final d in store.history()) d.date: d.steps,
    };
    final key = store.todayDate.isEmpty ? todayKey() : store.todayDate;
    map[key] = store.todaySteps;
    return Scaffold(
      backgroundColor: pack.bg,
      appBar: AppBar(
        backgroundColor: pack.bg,
        foregroundColor: pack.ink,
        title: Text(easyUiLine(lang, 'thisWeek')),
        leadingWidth: 88,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(easyUiLine(lang, 'back')),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          WeekStrip(
            stepsByDate: map,
            goal: store.goal,
            now: DateTime.now(),
            language: lang,
            pack: pack,
            fontScale: Look.instance.fontScale,
            frosted: false,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: easyTapMin,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              },
              child: Text(easyUiLine(lang, 'history')),
            ),
          ),
        ],
      ),
    );
  }
}
