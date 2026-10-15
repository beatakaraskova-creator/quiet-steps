import 'dart:math';

import '../l10n/walk_text.dart';
import '../models/walk_entry.dart';

const maxWalkJournal = 500;
const maxWalkNote = 280;

int walkStepDifference(int startSteps, int currentSteps) {
  final d = currentSteps - startSteps;
  return d < 0 ? 0 : d;
}

int walkStepsNow({
  required int startSteps,
  required int currentSteps,
  int carry = 0,
}) {
  final extra = carry < 0 ? 0 : carry;
  return extra + walkStepDifference(startSteps, currentSteps);
}

int walkCarryAfterMidnight({
  required bool walkActive,
  required int startSteps,
  required int yesterdaySteps,
  required int currentCarry,
}) {
  if (!walkActive) return currentCarry < 0 ? 0 : currentCarry;
  final base = currentCarry < 0 ? 0 : currentCarry;
  return base + walkStepDifference(startSteps, yesterdaySteps);
}

int walkMinutes(DateTime start, DateTime end) {
  final m = end.difference(start).inMinutes;
  return m < 0 ? 0 : m;
}

String walkUiLine(String language, String key) {
  final lang = walkUi.containsKey(language) ? language : 'en';
  return walkUi[lang]?[key] ?? walkUi['en']?[key] ?? key;
}

String walkMoodLabel(String language, String mood) {
  final lang = walkMoodLabels.containsKey(language) ? language : 'en';
  return walkMoodLabels[lang]?[mood] ??
      walkMoodLabels['en']?[mood] ??
      mood;
}

String walkMinutesLabel(String language, int n) {
  final key = n.abs() == 1 ? 'minOne' : 'minOther';
  return walkUiLine(language, key).replaceAll('{n}', '$n');
}

String pickWalkLine({
  required String language,
  required String mood,
  int Function(int max)? nextInt,
}) {
  final lang = walkLines.containsKey(language) ? language : 'en';
  var lines = walkLines[lang]?[mood];
  if (lines == null || lines.isEmpty) {
    lines = walkLines['en']?[mood] ?? walkLines['en']!['move']!;
  }
  final pick = nextInt ?? Random().nextInt;
  final i = pick(lines.length).clamp(0, lines.length - 1);
  return lines[i];
}

String clipWalkNote(String raw) {
  final t = raw.trim();
  if (t.length <= maxWalkNote) return t;
  return t.substring(0, maxWalkNote);
}

/// Newest first. Oldest dropped when over [max].
List<WalkEntry> addWalkEntry(
  List<WalkEntry> current,
  WalkEntry entry, {
  int max = maxWalkJournal,
}) {
  final next = [entry, ...current];
  if (next.length <= max) return next;
  return next.take(max).toList();
}

List<WalkEntry> deleteWalkEntry(List<WalkEntry> current, String id) {
  return current.where((e) => e.id != id).toList();
}

WalkEntry finishWalk({
  required String mood,
  required int startSteps,
  required int currentSteps,
  required DateTime start,
  required DateTime end,
  String note = '',
  String? id,
  int carry = 0,
}) {
  return WalkEntry(
    id: id ?? '${end.millisecondsSinceEpoch}',
    mood: mood,
    steps: walkStepsNow(
      startSteps: startSteps,
      currentSteps: currentSteps,
      carry: carry,
    ),
    minutes: walkMinutes(start, end),
    note: clipWalkNote(note),
    startedAt: start.toIso8601String(),
    endedAt: end.toIso8601String(),
  );
}
