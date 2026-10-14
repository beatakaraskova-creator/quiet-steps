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
        ['2500', 'goal'],
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
