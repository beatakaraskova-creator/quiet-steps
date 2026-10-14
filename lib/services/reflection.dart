import 'dart:math';

import '../l10n/reflection_lines.dart';
import '../l10n/streak_text.dart';
import 'milestones.dart';
import 'step_math.dart';
import 'streaks.dart';

/// 'met' | 'half' | 'under'
String reflectionGroup({required int steps, required int goal}) {
  if (goal <= 0) return steps > 0 ? 'met' : 'under';
  if (steps >= goal) return 'met';
  if (steps * 2 >= goal) return 'half';
  return 'under';
}

String pickReflectionClosing({
  required String language,
  required String group,
  int Function(int max)? nextInt,
}) {
  final lang = reflectionClosings.containsKey(language) ? language : 'en';
  var lines = reflectionClosings[lang]?[group];
  if (lines == null || lines.isEmpty) {
    lines = reflectionClosings['en']?[group] ?? reflectionClosings['en']!['under']!;
  }
  final pick = nextInt ?? Random().nextInt;
  final i = pick(lines.length).clamp(0, lines.length - 1);
  return lines[i];
}

String reflectionSummaryLine(String language, int steps) {
  final lang = reflectionSummary.containsKey(language) ? language : 'en';
  final n = steps.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return (reflectionSummary[lang] ?? reflectionSummary['en']!)
      .replaceAll('{n}', n);
}

String reflectionUiLine(String language, String key) {
  final lang = reflectionUi.containsKey(language) ? language : 'en';
  return reflectionUi[lang]?[key] ?? reflectionUi['en']![key]!;
}

/// Fire once per calendar day, at or after [timeHm].
bool shouldFireReflection({
  required bool enabled,
  required String lastFiredDate,
  required String timeHm,
  required DateTime now,
}) {
  if (!enabled) return false;
  final today = todayKey(now);
  if (lastFiredDate == today) return false;
  final nowMins = now.hour * 60 + now.minute;
  return nowMins >= minutesFromHm(timeHm);
}

bool isAfterReflectionTime({
  required String timeHm,
  required DateTime now,
}) {
  return (now.hour * 60 + now.minute) >= minutesFromHm(timeHm);
}

/// Silent when quiet hours are on and the reflection clock time sits in them.
bool reflectionIsSilent({
  required bool quietOn,
  required String quietStart,
  required String quietEnd,
  required String timeHm,
}) {
  if (!quietOn) return false;
  final mins = minutesFromHm(timeHm);
  final at = DateTime(2026, 6, 15, mins ~/ 60, mins % 60);
  return inQuietHours(start: quietStart, end: quietEnd, now: at);
}

String reflectionStreakLine({
  required Map<String, int> stepsByDate,
  required int goal,
  required DateTime now,
  required String language,
}) {
  final snap = computeStreak(
    stepsByDate: stepsByDate,
    goal: goal,
    now: now,
  );
  if (snap.restDates.contains(todayKey(now))) {
    return StreakText.restDay(language);
  }
  if (snap.goodDays >= 1) {
    return StreakText.goodDays(language, snap.goodDays);
  }
  return StreakText.freshStart(language);
}

class ReflectionCopy {
  const ReflectionCopy({
    required this.summary,
    required this.closing,
    required this.streak,
  });

  final String summary;
  final String closing;
  final String streak;

  String get spoken => '$summary $closing $streak';
}

ReflectionCopy buildReflectionCopy({
  required int steps,
  required int goal,
  required Map<String, int> stepsByDate,
  required DateTime now,
  required String language,
  int Function(int max)? nextInt,
}) {
  final group = reflectionGroup(steps: steps, goal: goal);
  return ReflectionCopy(
    summary: reflectionSummaryLine(language, steps),
    closing: pickReflectionClosing(
      language: language,
      group: group,
      nextInt: nextInt,
    ),
    streak: reflectionStreakLine(
      stepsByDate: stepsByDate,
      goal: goal,
      now: now,
      language: language,
    ),
  );
}
