import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/walk_text.dart';
import 'package:quiet_steps/models/walk_entry.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:quiet_steps/services/walks.dart';
import 'package:shared_preferences/shared_preferences.dart';

WalkEntry _entry(String id, {String note = '', int steps = 10}) {
  return WalkEntry(
    id: id,
    mood: 'move',
    steps: steps,
    minutes: 1,
    note: note,
    startedAt: '2026-10-14T10:00:00.000',
    endedAt: '2026-10-14T10:01:00.000',
  );
}

void main() {
  group('walk step difference', () {
    test('uses current minus start', () {
      expect(walkStepDifference(1000, 1500), 500);
      expect(walkStepDifference(0, 42), 42);
      expect(walkStepDifference(800, 800), 0);
    });

    test('clamps a drop in the day count to zero', () {
      expect(walkStepDifference(1000, 900), 0);
      expect(walkStepDifference(50, -1), 0);
    });

    test('finishWalk stores the difference and minutes', () {
      final start = DateTime(2026, 10, 14, 10, 0);
      final end = DateTime(2026, 10, 14, 10, 17);
      final walk = finishWalk(
        mood: 'clear',
        startSteps: 200,
        currentSteps: 450,
        start: start,
        end: end,
        note: '  birds  ',
      );
      expect(walk.mood, 'clear');
      expect(walk.steps, 250);
      expect(walk.minutes, 17);
      expect(walk.note, 'birds');
    });

    test('walkMinutes is never negative', () {
      final a = DateTime(2026, 10, 14, 10);
      expect(walkMinutes(a, a), 0);
      expect(walkMinutes(a, a.add(const Duration(seconds: 59))), 0);
      expect(walkMinutes(a, a.add(const Duration(minutes: 2))), 2);
      expect(walkMinutes(a, a.subtract(const Duration(minutes: 5))), 0);
    });
  });

  group('mood line selection', () {
    test('picks the line for that mood from its group', () {
      expect(
        pickWalkLine(language: 'en', mood: 'clear', nextInt: (_) => 0),
        'Hopefully your mind feels a little lighter now.',
      );
      expect(
        pickWalkLine(language: 'en', mood: 'clear', nextInt: (_) => 1),
        'Fresh air, clearer thoughts. Well done.',
      );
      expect(
        pickWalkLine(language: 'en', mood: 'gratitude', nextInt: (_) => 0),
        'Thank you for taking this time for yourself.',
      );
      expect(
        pickWalkLine(language: 'en', mood: 'move', nextInt: (_) => 1),
        "You moved. That's what matters.",
      );
      expect(
        pickWalkLine(language: 'en', mood: 'slow', nextInt: (_) => 0),
        'Gentle and unhurried. Just right.',
      );
      expect(
        pickWalkLine(language: 'en', mood: 'energy', nextInt: (_) => 1),
        'Feel that energy? Well done!',
      );
    });

    test('unknown language falls back to English', () {
      expect(
        pickWalkLine(language: 'xx', mood: 'slow', nextInt: (_) => 1),
        'You gave yourself some calm.',
      );
    });

    test('unknown mood falls back to just-move English', () {
      expect(
        pickWalkLine(language: 'en', mood: 'unknown', nextInt: (_) => 0),
        'Every step counted. Nice work.',
      );
    });

    test('Slovak line is used when language is sk', () {
      expect(
        pickWalkLine(language: 'sk', mood: 'move', nextInt: (_) => 0),
        'Každý krok sa počítal. Pekná práca.',
      );
    });

    test('every supported language has two lines per mood', () {
      for (final lang in supportedLanguages) {
        expect(walkLines[lang], isNotNull, reason: lang);
        for (final mood in walkMoodIds) {
          expect(
            walkLines[lang]![mood]?.length,
            2,
            reason: '$lang $mood',
          );
          expect(walkMoodLabels[lang]![mood], isNotEmpty);
        }
        for (final key in walkUi['en']!.keys) {
          expect(walkUi[lang]![key], isNotEmpty, reason: '$lang $key');
        }
      }
    });
  });

  group('journal save and delete', () {
    test('newest walk is first', () {
      var list = <WalkEntry>[];
      list = addWalkEntry(list, _entry('a'));
      list = addWalkEntry(list, _entry('b'));
      expect(list.map((e) => e.id), ['b', 'a']);
    });

    test('delete removes only that walk', () {
      var list = [
        _entry('a'),
        _entry('b'),
        _entry('c'),
      ];
      list = deleteWalkEntry(list, 'b');
      expect(list.map((e) => e.id), ['a', 'c']);
      list = deleteWalkEntry(list, 'missing');
      expect(list.map((e) => e.id), ['a', 'c']);
    });

    test('notes are trimmed and capped at 280', () {
      expect(clipWalkNote('  hello  '), 'hello');
      expect(clipWalkNote('x' * 280).length, 280);
      expect(clipWalkNote('x' * 281).length, 280);
    });

    test('store persists walks as a JSON list', () async {
      SharedPreferences.setMockInitialValues({});
      final store = Store.instance;
      await store.init();
      expect(store.walks(), isEmpty);
      expect(store.walkActive, isFalse);

      store.startWalk('gratitude', 120, DateTime(2026, 10, 14, 9));
      expect(store.walkActive, isTrue);
      expect(store.walkMood, 'gratitude');
      expect(store.walkStartSteps, 120);

      await store.addWalk(_entry('w1', note: 'quiet lane'));
      expect(store.walks().single.note, 'quiet lane');
      await store.deleteWalk('w1');
      expect(store.walks(), isEmpty);

      store.clearWalk();
      expect(store.walkActive, isFalse);
    });
  });

  group('500 entry limit', () {
    test('oldest is dropped first when over the cap', () {
      var list = <WalkEntry>[];
      list = addWalkEntry(list, _entry('a'), max: 3);
      list = addWalkEntry(list, _entry('b'), max: 3);
      list = addWalkEntry(list, _entry('c'), max: 3);
      expect(list.map((e) => e.id), ['c', 'b', 'a']);
      list = addWalkEntry(list, _entry('d'), max: 3);
      expect(list.length, 3);
      expect(list.map((e) => e.id), ['d', 'c', 'b']);
    });

    test('default cap is 500', () {
      expect(maxWalkJournal, 500);
      final filled = [for (var i = 0; i < 500; i++) _entry('$i')];
      final next = addWalkEntry(filled, _entry('new'));
      expect(next.length, 500);
      expect(next.first.id, 'new');
      expect(next.last.id, '498');
      expect(next.any((e) => e.id == '499'), isFalse);
    });
  });
}
