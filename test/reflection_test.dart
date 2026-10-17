import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/reflection_lines.dart';
import 'package:quiet_steps/services/reflection.dart';
import 'package:quiet_steps/services/step_math.dart';

void main() {
  group('line group selection', () {
    test('goal met uses the met group', () {
      expect(reflectionGroup(steps: 8000, goal: 8000), 'met');
      expect(reflectionGroup(steps: 9000, goal: 8000), 'met');
      expect(
        pickReflectionClosing(language: 'en', group: 'met', nextInt: (_) => 0),
        reflectionClosings['en']!['met']!.first,
      );
    });

    test('at least half the goal uses the half group', () {
      expect(reflectionGroup(steps: 4000, goal: 8000), 'half');
      expect(reflectionGroup(steps: 7999, goal: 8000), 'half');
      expect(
        pickReflectionClosing(language: 'en', group: 'half', nextInt: (_) => 0),
        reflectionClosings['en']!['half']![0],
      );
    });

    test('under half uses the under group', () {
      expect(reflectionGroup(steps: 0, goal: 8000), 'under');
      expect(reflectionGroup(steps: 3999, goal: 8000), 'under');
      expect(
        pickReflectionClosing(language: 'en', group: 'under', nextInt: (_) => 1),
        reflectionClosings['en']!['under']![1],
      );
    });

    test('unknown language falls back to English closings', () {
      expect(
        pickReflectionClosing(language: 'xx', group: 'met', nextInt: (_) => 2),
        reflectionClosings['en']!['met']![2],
      );
      expect(
        reflectionSummaryLine('zz', 2500),
        'Today you walked 2,500 steps.',
      );
    });

    test('Slovak summary is used when language is sk', () {
      expect(
        reflectionSummaryLine('sk', 8000),
        'Dnes ste prešli 8,000 krokov.',
      );
    });
  });

  group('notification firing once per day', () {
    final time = '20:30';

    test('does not fire before the chosen time', () {
      expect(
        shouldFireReflection(
          enabled: true,
          lastFiredDate: '',
          timeHm: time,
          now: DateTime(2026, 10, 14, 20, 29),
        ),
        isFalse,
      );
    });

    test('fires at the chosen time', () {
      expect(
        shouldFireReflection(
          enabled: true,
          lastFiredDate: '',
          timeHm: time,
          now: DateTime(2026, 10, 14, 20, 30),
        ),
        isTrue,
      );
    });

    test('does not fire again the same day', () {
      expect(
        shouldFireReflection(
          enabled: true,
          lastFiredDate: '2026-10-14',
          timeHm: time,
          now: DateTime(2026, 10, 14, 21, 0),
        ),
        isFalse,
      );
    });

    test('fires again the next day after the time', () {
      expect(
        shouldFireReflection(
          enabled: true,
          lastFiredDate: '2026-10-14',
          timeHm: time,
          now: DateTime(2026, 10, 15, 20, 30),
        ),
        isTrue,
      );
      expect(todayKey(DateTime(2026, 10, 15)), '2026-10-15');
    });

    test('stays off when the setting is disabled', () {
      expect(
        shouldFireReflection(
          enabled: false,
          lastFiredDate: '',
          timeHm: time,
          now: DateTime(2026, 10, 14, 21, 0),
        ),
        isFalse,
      );
    });
  });

  group('quiet hours', () {
    test('20:30 is not silent with default 22:00–07:00 quiet hours', () {
      expect(
        reflectionIsSilent(
          quietOn: true,
          quietStart: '22:00',
          quietEnd: '07:00',
          timeHm: '20:30',
        ),
        isFalse,
      );
    });

    test('a time inside quiet hours is silent', () {
      expect(
        reflectionIsSilent(
          quietOn: true,
          quietStart: '22:00',
          quietEnd: '07:00',
          timeHm: '23:00',
        ),
        isTrue,
      );
      expect(
        reflectionIsSilent(
          quietOn: true,
          quietStart: '22:00',
          quietEnd: '07:00',
          timeHm: '06:30',
        ),
        isTrue,
      );
    });

    test('quiet hours off means the notification is not silent', () {
      expect(
        reflectionIsSilent(
          quietOn: false,
          quietStart: '22:00',
          quietEnd: '07:00',
          timeHm: '23:00',
        ),
        isFalse,
      );
    });
  });
}
