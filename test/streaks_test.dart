import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quiet_steps/l10n/streak_text.dart';
import 'package:quiet_steps/services/step_math.dart';
import 'package:quiet_steps/services/streaks.dart';

void main() {
  final today = DateTime(2026, 10, 14); // Wednesday
  const goal = 8000;

  Map<String, int> daysAgo(Map<int, int> stepsAgo) {
    return {
      for (final e in stepsAgo.entries)
        todayKey(DateTime(today.year, today.month, today.day - e.key)): e.value,
    };
  }

  group('streak counting', () {
    test('counts consecutive goal days', () {
      final snap = computeStreak(
        stepsByDate: daysAgo({0: 8000, 1: 8100, 2: 9000, 3: 8000, 4: 8000}),
        goal: goal,
        now: today,
      );
      expect(snap.goodDays, 5);
      expect(snap.freshStart, isFalse);
      expect(snap.restDates, isEmpty);
    });

    test('today below goal is pending and does not count as a miss', () {
      final snap = computeStreak(
        stepsByDate: daysAgo({
          0: 400,
          1: 8000,
          2: 8000,
          3: 8000,
          4: 8000,
          5: 8000,
        }),
        goal: goal,
        now: today,
      );
      expect(snap.goodDays, 5);
      expect(snap.restDates, isEmpty);
    });
  });

  group('rest days', () {
    test('one rest day per 7 days does not break the streak', () {
      final snap = computeStreak(
        stepsByDate: daysAgo({
          0: 8000,
          1: 8000,
          2: 1200, // rest
          3: 8000,
          4: 8000,
          5: 8000,
          6: 8000,
        }),
        goal: goal,
        now: today,
      );
      expect(snap.goodDays, 6);
      expect(snap.restDates, {todayKey(DateTime(2026, 10, 12))});
      expect(snap.freshStart, isFalse);
    });

    test('a second miss within 7 days quietly restarts', () {
      final snap = computeStreak(
        stepsByDate: daysAgo({
          0: 500, // pending today
          1: 400, // miss
          2: 300, // miss
          3: 8000,
          4: 8000,
          5: 8000,
        }),
        goal: goal,
        now: today,
      );
      expect(snap.goodDays, 0);
      expect(snap.freshStart, isTrue);
      expect(snap.restDates, isEmpty);
    });

    test('after two misses a new good day starts a quiet fresh streak', () {
      final snap = computeStreak(
        stepsByDate: daysAgo({
          0: 8000,
          1: 400,
          2: 300,
          3: 8000,
          4: 9000,
        }),
        goal: goal,
        now: today,
      );
      expect(snap.goodDays, 1);
      expect(snap.restDates, {todayKey(DateTime(2026, 10, 13))});
    });

    test('misses 7 days apart can both be rest days', () {
      final snap = computeStreak(
        stepsByDate: daysAgo({
          0: 8000,
          1: 1000, // rest
          2: 8000,
          3: 8000,
          4: 8000,
          5: 8000,
          6: 8000,
          7: 8000,
          8: 1000, // rest, 7 days before the other miss
          9: 8000,
        }),
        goal: goal,
        now: today,
      );
      expect(snap.goodDays, 8);
      expect(
        snap.restDates,
        {
          todayKey(DateTime(2026, 10, 13)),
          todayKey(DateTime(2026, 10, 6)),
        },
      );
    });
  });

  group('week boundaries', () {
    test('current week is Monday to Sunday', () {
      final week = weekMondayToSunday(today);
      expect(week.length, 7);
      expect(todayKey(week.first), '2026-10-12');
      expect(week.first.weekday, DateTime.monday);
      expect(todayKey(week.last), '2026-10-18');
      expect(week.last.weekday, DateTime.sunday);
      expect(week[2], DateTime(2026, 10, 14));
    });

    test('week does not include the previous or next week', () {
      final keys = weekMondayToSunday(today).map(todayKey).toSet();
      expect(keys.contains('2026-10-11'), isFalse);
      expect(keys.contains('2026-10-19'), isFalse);
    });

    test('week can span a year boundary', () {
      final week = weekMondayToSunday(DateTime(2026, 1, 1)); // Thursday
      expect(todayKey(week.first), '2025-12-29');
      expect(todayKey(week.last), '2026-01-04');
    });

    test('week view marks today, future days, rest and goal', () {
      final steps = daysAgo({
        0: 8000, // Wed today
        1: 8000, // Tue
        2: 900, // Mon rest
      });
      final streak = computeStreak(stepsByDate: steps, goal: goal, now: today);
      final view = weekView(
        stepsByDate: steps,
        goal: goal,
        now: today,
        restDates: streak.restDates,
      );
      expect(view[0].isRest, isTrue); // Monday
      expect(view[0].metGoal, isFalse);
      expect(view[1].metGoal, isTrue); // Tuesday
      expect(view[2].isToday, isTrue); // Wednesday
      expect(view[3].isFuture, isTrue); // Thursday
      expect(view[6].isFuture, isTrue);
    });
  });

  group('copy', () {
    test('falls back to English', () {
      expect(StreakText.goodDays('xx', 5), '5 good days');
      expect(StreakText.freshStart('zz'), 'A fresh start today, and that is a lovely place to begin.');
      expect(StreakText.restDay('nope'), 'Rest day');
      expect(StreakText.thisWeek(''), 'This week');
      expect(StreakText.steps('xx', 2500), '2,500 steps');
    });

    test('uses the eight app languages', () {
      expect(StreakText.goodDays('sk', 5), '5 dobrých dní');
      expect(StreakText.goodDays('sk', 1), '1 dobrý deň');
      expect(StreakText.goodDays('cs', 3), '3 dobré dny');
      expect(StreakText.restDay('de'), 'Ruhetag');
      expect(StreakText.freshStart('fr'), "Aujourd'hui est un nouveau départ, et c'est un beau moment pour commencer.");
      expect(StreakText.thisWeek('it'), 'Questa settimana');
    });
  });

  test('weekday names come from intl for each language', () async {
    await initializeDateFormatting('sk');
    await initializeDateFormatting('en');
    final monday = DateTime(2026, 10, 12);
    expect(DateFormat.E('en').format(monday), 'Mon');
    expect(DateFormat.E('sk').format(monday), isNotEmpty);
  });
}
