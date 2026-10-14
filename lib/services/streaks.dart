import 'step_math.dart';

/// Monday–Sunday of the week that contains [now], date-only.
List<DateTime> weekMondayToSunday(DateTime now) {
  final day = DateTime(now.year, now.month, now.day);
  final monday = DateTime(day.year, day.month, day.day - (day.weekday - 1));
  return List<DateTime>.generate(
    7,
    (i) => DateTime(monday.year, monday.month, monday.day + i),
  );
}

class StreakSnapshot {
  const StreakSnapshot({
    required this.goodDays,
    required this.restDates,
  });

  final int goodDays;
  final Set<String> restDates;

  bool get freshStart => goodDays == 0;
}

class WeekDayInfo {
  const WeekDayInfo({
    required this.date,
    required this.steps,
    required this.isToday,
    required this.isFuture,
    required this.metGoal,
    required this.isRest,
  });

  final DateTime date;
  final int steps;
  final bool isToday;
  final bool isFuture;
  final bool metGoal;
  final bool isRest;

  String get key => todayKey(date);
}

/// Kind streak: goal-met days in a row, walking backwards from [now].
///
/// One missed day per rolling 7 days is a rest day and does not break
/// the streak. A second miss in that window quietly ends the walk.
/// Today is only a miss once it has met or the caller treats it as
/// closed; if today's steps are still below the goal, today is pending
/// and the streak is counted from yesterday.
StreakSnapshot computeStreak({
  required Map<String, int> stepsByDate,
  required int goal,
  required DateTime now,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final todayMet = _met(stepsByDate[todayKey(today)] ?? 0, goal);
  var cursor = todayMet ? today : DateTime(today.year, today.month, today.day - 1);

  DateTime? oldestRecord;
  for (final key in stepsByDate.keys) {
    final d = DateTime.tryParse(key);
    if (d == null) continue;
    final day = DateTime(d.year, d.month, d.day);
    if (oldestRecord == null || day.isBefore(oldestRecord)) {
      oldestRecord = day;
    }
  }

  var good = 0;
  final rest = <String>{};

  for (var i = 0; i < 90; i++) {
    if (oldestRecord != null && cursor.isBefore(oldestRecord)) break;
    final key = todayKey(cursor);
    if (_met(stepsByDate[key] ?? 0, goal)) {
      good++;
    } else {
      final close = rest.any((r) => _daysApart(cursor, DateTime.parse(r)) < 7);
      if (close) break;
      rest.add(key);
    }
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }

  if (good == 0) {
    return const StreakSnapshot(goodDays: 0, restDates: {});
  }
  return StreakSnapshot(goodDays: good, restDates: rest);
}

List<WeekDayInfo> weekView({
  required Map<String, int> stepsByDate,
  required int goal,
  required DateTime now,
  required Set<String> restDates,
}) {
  final today = DateTime(now.year, now.month, now.day);
  return [
    for (final d in weekMondayToSunday(now))
      WeekDayInfo(
        date: d,
        steps: stepsByDate[todayKey(d)] ?? 0,
        isToday: d == today,
        isFuture: d.isAfter(today),
        metGoal: _met(stepsByDate[todayKey(d)] ?? 0, goal),
        isRest: restDates.contains(todayKey(d)),
      ),
  ];
}

bool _met(int steps, int goal) => goal > 0 && steps >= goal;

int _daysApart(DateTime a, DateTime b) {
  final aa = DateTime(a.year, a.month, a.day);
  final bb = DateTime(b.year, b.month, b.day);
  return aa.difference(bb).inDays.abs();
}
