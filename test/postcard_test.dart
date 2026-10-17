import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/postcard_text.dart';
import 'package:quiet_steps/models/walk_entry.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/postcard.dart';
import 'package:quiet_steps/services/step_math.dart';

WalkEntry _walk(String iso) {
  return WalkEntry(
    id: iso,
    mood: 'move',
    steps: 100,
    minutes: 10,
    note: '',
    startedAt: iso,
    endedAt: iso,
  );
}

void main() {
  const goal = 8000;
  final now = DateTime(2026, 10, 14);

  Map<String, int> october() {
    return {
      todayKey(DateTime(2026, 10, 1)): 8200,
      todayKey(DateTime(2026, 10, 2)): 9100,
      todayKey(DateTime(2026, 10, 3)): 1200,
      todayKey(DateTime(2026, 10, 4)): 8000,
      todayKey(DateTime(2026, 10, 5)): 400,
      todayKey(DateTime(2026, 10, 10)): 14200,
      todayKey(DateTime(2026, 10, 13)): 8500,
      todayKey(DateTime(2026, 10, 14)): 3000,
    };
  }

  group('month totals', () {
    test('sums only days in the month up to today', () {
      final data = buildPostcard(
        year: 2026,
        month: 10,
        stepsByDate: october(),
        goal: goal,
        now: now,
        walks: const [],
      );
      expect(
        data.totalSteps,
        8200 + 9100 + 1200 + 8000 + 400 + 14200 + 8500 + 3000,
      );
      expect(data.elapsedDays, 14);
      expect(data.days.length, 31);
      expect(data.days[14].mark, PostcardMark.none);
      expect(data.days.last.day, 31);
    });

    test('ignores other months', () {
      final steps = {
        ...october(),
        todayKey(DateTime(2026, 9, 30)): 20000,
        todayKey(DateTime(2026, 11, 1)): 20000,
      };
      final data = buildPostcard(
        year: 2026,
        month: 10,
        stepsByDate: steps,
        goal: goal,
        now: now,
        walks: const [],
      );
      expect(data.totalSteps, 52600);
    });
  });

  group('good days', () {
    test('counts days that met the goal', () {
      final data = buildPostcard(
        year: 2026,
        month: 10,
        stepsByDate: october(),
        goal: goal,
        now: now,
        walks: const [],
      );
      expect(data.goodDays, 5);
      expect(data.days[0].mark, PostcardMark.gold);
      expect(data.days[2].mark, isNot(PostcardMark.gold));
    });
  });

  group('best day', () {
    test('is the highest step count in the month', () {
      final data = buildPostcard(
        year: 2026,
        month: 10,
        stepsByDate: october(),
        goal: goal,
        now: now,
        walks: const [],
      );
      expect(data.bestDaySteps, 14200);
    });

    test('is zero when the month has no steps', () {
      final data = buildPostcard(
        year: 2026,
        month: 9,
        stepsByDate: october(),
        goal: goal,
        now: now,
        walks: const [],
      );
      expect(data.bestDaySteps, 0);
      expect(data.totalSteps, 0);
    });
  });

  group('line choice', () {
    test('mostly when at least half the elapsed days met the goal', () {
      expect(
        postcardLineGroup(goodDays: 7, elapsedDays: 14),
        'mostly',
      );
      expect(
        postcardLineGroup(goodDays: 15, elapsedDays: 30),
        'mostly',
      );
      expect(
        postcardClosingLine('en', 'mostly', day: DateTime(2026, 10, 20)),
        postcardLines['en']!['mostly'],
      );
    });

    test('some when there are good days but fewer than half', () {
      expect(postcardLineGroup(goodDays: 5, elapsedDays: 14), 'some');
      expect(
        postcardClosingLine('en', 'some', day: DateTime(2026, 10, 20)),
        postcardLines['en']!['some'],
      );
    });

    test('quiet when there are no good days', () {
      expect(postcardLineGroup(goodDays: 0, elapsedDays: 14), 'quiet');
      expect(
        postcardClosingLine('en', 'quiet', day: DateTime(2026, 10, 20)),
        postcardLines['en']!['quiet'],
      );
    });

    test('unknown language falls back to English', () {
      expect(
        postcardClosingLine('xx', 'quiet', day: DateTime(2026, 10, 25)),
        postcardDayLines['en']!['quiet']![6],
      );
    });

    test('October sample with 5 of 14 good days uses some', () {
      final data = buildPostcard(
        year: 2026,
        month: 10,
        stepsByDate: october(),
        goal: goal,
        now: now,
        walks: const [],
      );
      expect(data.lineGroup, 'some');
    });

    test('every supported language has the three lines and UI keys', () {
      for (final lang in supportedLanguages) {
        expect(postcardLines[lang]?['mostly'], isNotEmpty);
        expect(postcardLines[lang]?['some'], isNotEmpty);
        expect(postcardLines[lang]?['quiet'], isNotEmpty);
        for (final key in postcardUi['en']!.keys) {
          if (key == 'walksFew') continue;
          expect(postcardUi[lang]![key], isNotEmpty, reason: '$lang $key');
        }
      }
    });
  });

  group('walks in the month', () {
    test('counts journal entries that ended in the month', () {
      final walks = [
        _walk('2026-10-02T09:00:00.000'),
        _walk('2026-10-14T18:00:00.000'),
        _walk('2026-09-30T12:00:00.000'),
      ];
      expect(walksInMonth(walks, 2026, 10), 2);
      final data = buildPostcard(
        year: 2026,
        month: 10,
        stepsByDate: october(),
        goal: goal,
        now: now,
        walks: walks,
      );
      expect(data.walkCount, 2);
    });
  });

  group('month navigation limits', () {
    test('cannot go past the current month', () {
      final view = DateTime(2026, 10, 1);
      expect(canGoNextMonth(view, view), isFalse);
      expect(canGoNextMonth(DateTime(2026, 9, 1), view), isTrue);
    });

    test('cannot go before the earliest month with history', () {
      final earliest = earliestPostcardMonth(
        dayKeys: ['2026-08-20', '2026-10-01'],
        walkIsos: ['2026-07-15T10:00:00.000'],
        now: now,
      );
      expect(earliest, DateTime(2026, 7, 1));
      expect(canGoPrevMonth(DateTime(2026, 7, 1), earliest), isFalse);
      expect(canGoPrevMonth(DateTime(2026, 8, 1), earliest), isTrue);
      expect(canGoPrevMonth(DateTime(2026, 10, 1), earliest), isTrue);
    });

    test('with no history the earliest month is this month', () {
      final earliest = earliestPostcardMonth(
        dayKeys: const [],
        walkIsos: const [],
        now: now,
      );
      expect(earliest, DateTime(2026, 10, 1));
      expect(canGoPrevMonth(earliest, earliest), isFalse);
      expect(canGoNextMonth(earliest, earliest), isFalse);
    });

    test('prev and next move by one calendar month', () {
      expect(prevMonth(DateTime(2026, 1, 1)), DateTime(2025, 12, 1));
      expect(nextMonth(DateTime(2026, 12, 1)), DateTime(2027, 1, 1));
    });
  });
}
