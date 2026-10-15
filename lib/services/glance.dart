import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/glance_text.dart';
import '../l10n/streak_text.dart';
import '../models/look_pack.dart';
import 'easy_mode.dart';
import 'milestones.dart';
import 'step_math.dart';
import 'store.dart';
import 'streaks.dart';

const glanceThrottle = Duration(minutes: 1);

const glanceSmallAndroidName = 'QuietStepsSmallWidget';
const glanceMediumAndroidName = 'QuietStepsMediumWidget';
const glanceSmallQualified = 'com.wain.quiet_steps.QuietStepsSmallWidget';
const glanceMediumQualified = 'com.wain.quiet_steps.QuietStepsMediumWidget';

const _kPushMs = 'glance_push_ms';
const _kIdentity = 'glance_identity';
const _kSteps = 'glance_steps';

enum GlanceStatusKind { toGo, goalReached, restDay }

class GlanceData {
  const GlanceData({
    required this.steps,
    required this.goal,
    required this.progressPermille,
    required this.stepsLabel,
    required this.statusLine,
    required this.statusKind,
    required this.streakLine,
    required this.streakDays,
    required this.isRestDay,
    required this.goalReached,
    required this.date,
    required this.language,
    required this.bg,
    required this.accent,
    required this.ink,
    required this.muted,
    required this.line,
    required this.light,
    required this.bigSimple,
  });

  final int steps;
  final int goal;
  final int progressPermille;
  final String stepsLabel;
  final String statusLine;
  final GlanceStatusKind statusKind;
  final String streakLine;
  final int streakDays;
  final bool isRestDay;
  final bool goalReached;
  final String date;
  final String language;
  final int bg;
  final int accent;
  final int ink;
  final int muted;
  final int line;
  final bool light;
  final bool bigSimple;

  /// Identity that bypasses the once-a-minute count throttle.
  String get identity {
    return '$date|$goal|$streakDays|${statusKind.name}|$bg|$accent|$language|$light|$bigSimple';
  }
}

GlanceStatusKind glanceStatusKind({
  required int steps,
  required int goal,
  required bool isRestDay,
}) {
  if (goal > 0 && steps >= goal) return GlanceStatusKind.goalReached;
  if (isRestDay) return GlanceStatusKind.restDay;
  return GlanceStatusKind.toGo;
}

String glanceStatusLine({
  required String language,
  required int steps,
  required int goal,
  required bool isRestDay,
}) {
  switch (glanceStatusKind(steps: steps, goal: goal, isRestDay: isRestDay)) {
    case GlanceStatusKind.goalReached:
      return glanceGoalReached(language);
    case GlanceStatusKind.restDay:
      return StreakText.restDay(language);
    case GlanceStatusKind.toGo:
      final remaining = goal > steps ? goal - steps : 0;
      return glanceStepsToGoLine(language, remaining);
  }
}

int glanceProgressPermille(int steps, int goal) {
  if (goal <= 0) return 0;
  final v = ((steps * 1000) / goal).round();
  if (v < 0) return 0;
  if (v > 1000) return 1000;
  return v;
}

LookPack glancePackFromStore(Store store) {
  final base = store.lookCustom
      ? LookPack.custom(
          bg: Color(store.lookBgColor),
          accent: Color(store.lookAccent),
        )
      : LookPack.byId(store.lookId);
  return store.bigSimple ? accessibleLook(base) : base;
}

Map<String, int> glanceStepsByDate(Store store, DateTime now) {
  final map = <String, int>{
    for (final d in store.history()) d.date: d.steps,
  };
  final today = todayKey(now);
  if (store.todayDate.isEmpty || store.todayDate == today) {
    map[today] = store.todaySteps;
  } else {
    map[store.todayDate] = store.todaySteps;
    map.putIfAbsent(today, () => 0);
  }
  return map;
}

int glanceTodaySteps(Store store, DateTime now) {
  final today = todayKey(now);
  if (store.todayDate.isEmpty || store.todayDate == today) {
    return store.todaySteps;
  }
  return 0;
}

GlanceData buildGlanceData({
  required int steps,
  required int goal,
  required Map<String, int> stepsByDate,
  required DateTime now,
  required String language,
  required LookPack pack,
  bool? restToday,
  bool bigSimple = false,
}) {
  final date = todayKey(now);
  final lang = glanceLang(language);
  final safeGoal = goal < 0 ? 0 : goal;
  final safeSteps = steps < 0 ? 0 : steps;
  final streak = computeStreak(
    stepsByDate: stepsByDate,
    goal: safeGoal,
    now: now,
  );
  final isRest = restToday ?? streak.restDates.contains(date);
  final kind = glanceStatusKind(
    steps: safeSteps,
    goal: safeGoal,
    isRestDay: isRest,
  );
  return GlanceData(
    steps: safeSteps,
    goal: safeGoal,
    progressPermille: glanceProgressPermille(safeSteps, safeGoal),
    stepsLabel: glanceFormatNumber(safeSteps, lang),
    statusLine: glanceStatusLine(
      language: lang,
      steps: safeSteps,
      goal: safeGoal,
      isRestDay: isRest,
    ),
    statusKind: kind,
    streakLine: StreakText.goodDays(lang, streak.goodDays),
    streakDays: streak.goodDays,
    isRestDay: isRest,
    goalReached: kind == GlanceStatusKind.goalReached,
    date: date,
    language: lang,
    bg: pack.bg.toARGB32(),
    accent: pack.accent.toARGB32(),
    ink: pack.ink.toARGB32(),
    muted: pack.muted.toARGB32(),
    line: pack.line.toARGB32(),
    light: pack.light,
    bigSimple: bigSimple,
  );
}

GlanceData glanceDataFromStore(
  Store store, {
  DateTime? now,
  String? deviceLanguage,
}) {
  final at = now ?? DateTime.now();
  final lang = resolveLanguage(
    stored: store.language,
    deviceLanguageCode:
        deviceLanguage ?? PlatformDispatcher.instance.locale.languageCode,
  );
  return buildGlanceData(
    steps: glanceTodaySteps(store, at),
    goal: store.goal,
    stepsByDate: glanceStepsByDate(store, at),
    now: at,
    language: lang,
    pack: glancePackFromStore(store),
    bigSimple: store.bigSimple,
  );
}

/// Count changes wait [throttle]. Midnight, goal, streak, look and language
/// changes push immediately.
bool shouldPushGlance({
  required DateTime now,
  required DateTime? lastPush,
  required String lastIdentity,
  required String nextIdentity,
  required int lastSteps,
  required int nextSteps,
  Duration throttle = glanceThrottle,
}) {
  if (lastPush == null) return true;
  if (nextIdentity != lastIdentity) return true;
  if (nextSteps == lastSteps) return false;
  return now.difference(lastPush) >= throttle;
}

Future<void> pushQuietStepsWidget({
  Store? store,
  DateTime? now,
  String? deviceLanguage,
  bool force = false,
}) async {
  try {
    final s = store ?? Store.instance;
    final at = now ?? DateTime.now();
    final data = glanceDataFromStore(
      s,
      now: at,
      deviceLanguage: deviceLanguage,
    );
    final prefs = await SharedPreferences.getInstance();
    final lastMs = prefs.getInt(_kPushMs);
    final lastPush =
        lastMs == null ? null : DateTime.fromMillisecondsSinceEpoch(lastMs);
    final lastIdentity = prefs.getString(_kIdentity) ?? '';
    final lastSteps = prefs.getInt(_kSteps) ?? -1;
    if (!force &&
        !shouldPushGlance(
          now: at,
          lastPush: lastPush,
          lastIdentity: lastIdentity,
          nextIdentity: data.identity,
          lastSteps: lastSteps,
          nextSteps: data.steps,
        )) {
      return;
    }
    await HomeWidget.saveWidgetData<int>('steps', data.steps);
    await HomeWidget.saveWidgetData<int>('goal', data.goal);
    await HomeWidget.saveWidgetData<int>('progress', data.progressPermille);
    await HomeWidget.saveWidgetData<String>('stepsLabel', data.stepsLabel);
    await HomeWidget.saveWidgetData<String>('status', data.statusLine);
    await HomeWidget.saveWidgetData<String>('streak', data.streakLine);
    await HomeWidget.saveWidgetData<int>('streakDays', data.streakDays);
    await HomeWidget.saveWidgetData<bool>('rest', data.isRestDay);
    await HomeWidget.saveWidgetData<bool>('goalReached', data.goalReached);
    await HomeWidget.saveWidgetData<String>('date', data.date);
    await HomeWidget.saveWidgetData<String>('language', data.language);
    await HomeWidget.saveWidgetData<int>('bg', data.bg);
    await HomeWidget.saveWidgetData<int>('accent', data.accent);
    await HomeWidget.saveWidgetData<int>('ink', data.ink);
    await HomeWidget.saveWidgetData<int>('muted', data.muted);
    await HomeWidget.saveWidgetData<int>('line', data.line);
    await HomeWidget.saveWidgetData<bool>('light', data.light);
    await HomeWidget.saveWidgetData<bool>('bigSimple', data.bigSimple);
    await HomeWidget.updateWidget(
      name: glanceSmallAndroidName,
      androidName: glanceSmallAndroidName,
      qualifiedAndroidName: glanceSmallQualified,
    );
    await HomeWidget.updateWidget(
      name: glanceMediumAndroidName,
      androidName: glanceMediumAndroidName,
      qualifiedAndroidName: glanceMediumQualified,
    );
    await prefs.setInt(_kPushMs, at.millisecondsSinceEpoch);
    await prefs.setString(_kIdentity, data.identity);
    await prefs.setInt(_kSteps, data.steps);
  } catch (_) {
    // Widget push must never break step counting.
  }
}

void scheduleQuietStepsWidgetPush({bool force = false}) {
  unawaited(pushQuietStepsWidget(force: force));
}
