import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/milestone_lines.dart';
import 'package:quiet_steps/services/milestones.dart';

void main() {
  group('newlyCrossedMilestones', () {
    test('fires each milestone once per day', () {
      var fired = <String>{};

      final first = newlyCrossedMilestones(
        previousSteps: 2499,
        currentSteps: 2500,
        goal: 8000,
        alreadyFired: fired,
      );
      expect(first, ['2500']);
      fired.addAll(first);

      final again = newlyCrossedMilestones(
        previousSteps: 2500,
        currentSteps: 2600,
        goal: 8000,
        alreadyFired: fired,
      );
      expect(again, isEmpty);

      final next = newlyCrossedMilestones(
        previousSteps: 4999,
        currentSteps: 5001,
        goal: 8000,
        alreadyFired: fired,
      );
      expect(next, ['5000']);
      fired.addAll(next);

      final nextAgain = newlyCrossedMilestones(
        previousSteps: 5001,
        currentSteps: 5100,
        goal: 8000,
        alreadyFired: fired,
      );
      expect(nextAgain, isEmpty);
    });

    test('a new day starts with an empty fired set', () {
      final yesterday = firedKeysForDate('2026-10-13:2500,5000,goal', '2026-10-14');
      expect(yesterday, isEmpty);

      final keys = newlyCrossedMilestones(
        previousSteps: 2490,
        currentSteps: 2510,
        goal: 8000,
        alreadyFired: yesterday,
      );
      expect(keys, ['2500']);
    });

    test('same-day fired keys are kept', () {
      expect(
        firedKeysForDate('2026-10-14:2500,5000', '2026-10-14'),
        {'2500', '5000'},
      );
    });

    test('skips milestones at or above the goal', () {
      expect(
        newlyCrossedMilestones(
          previousSteps: 0,
          currentSteps: 6000,
          goal: 3000,
          alreadyFired: {},
        ),
        ['2500', 'goal', '5500'],
      );

      expect(
        newlyCrossedMilestones(
          previousSteps: 2400,
          currentSteps: 2600,
          goal: 3000,
          alreadyFired: {},
        ),
        ['2500'],
      );

      expect(
        newlyCrossedMilestones(
          previousSteps: 2900,
          currentSteps: 3100,
          goal: 3000,
          alreadyFired: {'2500'},
        ),
        ['goal'],
      );

      expect(
        newlyCrossedMilestones(
          previousSteps: 4900,
          currentSteps: 5100,
          goal: 3000,
          alreadyFired: {'2500', 'goal'},
        ),
        isEmpty,
      );
    });

    test('goal equal to a milestone uses the goal message', () {
      expect(
        newlyCrossedMilestones(
          previousSteps: 0,
          currentSteps: 5000,
          goal: 5000,
          alreadyFired: {},
        ),
        ['2500', 'goal'],
      );
    });
  });

  group('beyond the goal', () {
    test('schedule for common goals', () {
      expect(
        beyondGoalThresholds(6000, upTo: 30000),
        [8500, 10000, 13500, 15000, 18500, 20000, 25000, 30000],
      );
      expect(
        beyondGoalThresholds(8000, upTo: 30000),
        [10000, 13000, 15000, 18000, 20000, 25000, 30000],
      );
      expect(
        beyondGoalThresholds(10000, upTo: 30000),
        [12500, 15000, 17500, 20000, 25000, 30000],
      );
      expect(
        beyondGoalThresholds(15000, upTo: 30000),
        [17500, 20000, 25000, 30000],
      );
    });

    test('round numbers replace a regular tick within 1,000 steps', () {
      expect(beyondGoalThresholds(8000, upTo: 20000), isNot(contains(10500)));
      expect(beyondGoalThresholds(8000, upTo: 20000), contains(10000));
      expect(beyondGoalThresholds(8000, upTo: 20000), isNot(contains(15500)));
      expect(beyondGoalThresholds(8000, upTo: 20000), contains(15000));
      expect(
        pickMilestoneLine(
          language: 'en',
          style: 'calm',
          milestone: '10000',
          nextInt: (_) => 0,
        ),
        milestoneLines['en']!['calm']!['round_10000']!.first,
      );
      expect(
        pickMilestoneLine(
          language: 'en',
          style: 'cheerful',
          milestone: '30000',
          nextInt: (_) => 0,
        ),
        milestoneLines['en']!['cheerful']!['round_30000']!.first,
      );
      expect(
        pickMilestoneLine(
          language: 'en',
          style: 'calm',
          milestone: '13000',
          nextInt: (_) => 0,
        ),
        milestoneLines['en']!['calm']!['beyond']!.first,
      );
      expect(
        pickMilestoneLine(
          language: 'en',
          style: 'calm',
          milestone: '35000',
          nextInt: (_) => 0,
        ),
        milestoneLines['en']!['calm']!['care_30k']!.first,
      );
    });

    test('no duplicates or messages within 1,000 steps after the goal', () {
      for (final goal in [3000, 6000, 8000, 9200, 10000, 15000, 19000]) {
        final beyond = beyondGoalThresholds(goal, upTo: 40000);
        expect(beyond.toSet().length, beyond.length, reason: 'goal $goal');
        for (final n in beyond) {
          expect(n - goal, greaterThan(beyondGoalMinGap), reason: 'goal $goal tick $n');
        }
        for (var i = 1; i < beyond.length; i++) {
          expect(
            beyond[i] - beyond[i - 1],
            greaterThan(beyondGoalMinGap),
            reason: 'goal $goal ${beyond[i - 1]} then ${beyond[i]}',
          );
        }
        for (final special in roundNumberSpecials) {
          if (special > goal && (special - goal) > beyondGoalMinGap) {
            expect(beyond, contains(special), reason: 'goal $goal missing $special');
          }
        }
      }
    });

    test('fires a beyond-goal tick once, including round specials', () {
      var fired = <String>{'2500', '5000', '7500', 'goal'};
      final ten = newlyCrossedMilestones(
        previousSteps: 9999,
        currentSteps: 10000,
        goal: 8000,
        alreadyFired: fired,
      );
      expect(ten, ['10000']);
      fired.addAll(ten);

      expect(
        newlyCrossedMilestones(
          previousSteps: 10499,
          currentSteps: 10500,
          goal: 8000,
          alreadyFired: fired,
        ),
        isEmpty,
      );

      final next = newlyCrossedMilestones(
        previousSteps: 12999,
        currentSteps: 13000,
        goal: 8000,
        alreadyFired: fired,
      );
      expect(next, ['13000']);
    });

    test('high counts keep a 5,000 step cadence after 20,000', () {
      expect(
        beyondGoalThresholds(8000, upTo: 40000).where((n) => n > 20000),
        [25000, 30000, 35000, 40000],
      );
    });
  });

  group('quiet hours', () {
    test('window spanning midnight', () {
      bool at(int hour, int minute) => inQuietHours(
            start: '22:00',
            end: '07:00',
            now: DateTime(2026, 10, 14, hour, minute),
          );

      expect(at(21, 59), isFalse);
      expect(at(22, 0), isTrue);
      expect(at(23, 30), isTrue);
      expect(at(0, 0), isTrue);
      expect(at(3, 15), isTrue);
      expect(at(6, 59), isTrue);
      expect(at(7, 0), isFalse);
      expect(at(12, 0), isFalse);
    });

    test('same-day window', () {
      bool at(int hour, int minute) => inQuietHours(
            start: '09:00',
            end: '17:00',
            now: DateTime(2026, 10, 14, hour, minute),
          );

      expect(at(8, 59), isFalse);
      expect(at(9, 0), isTrue);
      expect(at(16, 59), isTrue);
      expect(at(17, 0), isFalse);
    });

    test('equal start and end is an empty window', () {
      expect(
        inQuietHours(
          start: '22:00',
          end: '22:00',
          now: DateTime(2026, 10, 14, 22, 0),
        ),
        isFalse,
      );
    });
  });

  group('language fallback', () {
    test('unknown language uses English lines', () {
      expect(
        pickMilestoneLine(
          language: 'xx',
          style: 'calm',
          milestone: '2500',
          nextInt: (_) => 0,
        ),
        milestoneLines['en']!['calm']!['2500']!.first,
      );
    });

    test('unknown device language with Automatic falls back to en', () {
      expect(
        resolveLanguage(stored: 'auto', deviceLanguageCode: 'ja'),
        'en',
      );
      expect(
        resolveLanguage(stored: 'auto', deviceLanguageCode: 'sk_SK'),
        'sk',
      );
      expect(
        resolveLanguage(stored: 'fr', deviceLanguageCode: 'de'),
        'fr',
      );
      expect(
        resolveLanguage(stored: 'pt', deviceLanguageCode: 'en'),
        'en',
      );
    });

    test('known language uses its own lines', () {
      expect(
        pickMilestoneLine(
          language: 'sk',
          style: 'calm',
          milestone: '2500',
          nextInt: (_) => 0,
        ),
        milestoneLines['sk']!['calm']!['2500']!.first,
      );
    });
  });
}
