import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/glance_text.dart';
import 'package:quiet_steps/models/look_pack.dart';
import 'package:quiet_steps/services/glance.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/step_math.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:quiet_steps/l10n/streak_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 14, 9, 30);
  const goal = 8000;
  const pack = LookPack.quietGold;

  Map<String, int> days(Map<int, int> ago) {
    return {
      for (final e in ago.entries)
        todayKey(DateTime(now.year, now.month, now.day - e.key)): e.value,
    };
  }

  GlanceData build({
    int steps = 4218,
    int dailyGoal = goal,
    Map<String, int>? stepsByDate,
    String language = 'en',
    LookPack look = pack,
    bool? restToday,
    DateTime? at,
  }) {
    final t = at ?? now;
    final map = stepsByDate ??
        days({0: steps, 1: 8100, 2: 9000, 3: 8000});
    return buildGlanceData(
      steps: steps,
      goal: dailyGoal,
      stepsByDate: map,
      now: t,
      language: language,
      pack: look,
      restToday: restToday,
    );
  }

  group('widget data builder', () {
    test('steps, goal and progress', () {
      final data = build(steps: 4000, dailyGoal: 8000);
      expect(data.steps, 4000);
      expect(data.goal, 8000);
      expect(data.progressPermille, 500);
      expect(data.stepsLabel, '4,000');
      expect(data.goalReached, isFalse);
      expect(data.statusKind, GlanceStatusKind.toGo);
      expect(data.statusLine, '4,000 steps to go');
    });

    test('progress clamps at 0 and 1000', () {
      expect(glanceProgressPermille(0, 8000), 0);
      expect(glanceProgressPermille(8000, 8000), 1000);
      expect(glanceProgressPermille(12000, 8000), 1000);
      expect(glanceProgressPermille(100, 0), 0);
    });

    test('goal reached status', () {
      final data = build(steps: 8000);
      expect(data.goalReached, isTrue);
      expect(data.statusKind, GlanceStatusKind.goalReached);
      expect(data.statusLine, 'Goal reached');
      expect(data.progressPermille, 1000);
    });

    test('rest day status', () {
      final data = build(steps: 400, restToday: true);
      expect(data.isRestDay, isTrue);
      expect(data.statusKind, GlanceStatusKind.restDay);
      expect(data.statusLine, 'Rest day');
    });

    test('goal reached wins over rest day', () {
      final data = build(steps: 8000, restToday: true);
      expect(data.statusKind, GlanceStatusKind.goalReached);
      expect(data.statusLine, 'Goal reached');
    });

    test('streak line from consecutive goal days', () {
      final data = build(
        steps: 4000,
        stepsByDate: days({0: 4000, 1: 8100, 2: 9000, 3: 8000}),
      );
      expect(data.streakDays, 3);
      expect(data.streakLine, '3 good days');
    });

    test('uses look colours', () {
      final data = build(look: LookPack.paper);
      expect(data.bg, LookPack.paper.bg.toARGB32());
      expect(data.accent, LookPack.paper.accent.toARGB32());
      expect(data.ink, LookPack.paper.ink.toARGB32());
      expect(data.light, isTrue);
    });

    test('unknown language falls back to English', () {
      final data = build(language: 'xx', steps: 100);
      expect(data.language, 'en');
      expect(data.statusLine, '7,900 steps to go');
    });
  });

  group('status line in all languages', () {
    test('steps to go, goal reached and rest day', () {
      for (final lang in supportedLanguages) {
        expect(glanceUi[lang], isNotNull, reason: lang);
        for (final key in [
          'smallLabel',
          'smallDescription',
          'mediumLabel',
          'mediumDescription',
        ]) {
          expect(glanceUiLine(lang, key), isNotEmpty, reason: '$lang $key');
        }
        expect(glanceStepsToGoLine(lang, 1), isNotEmpty);
        expect(glanceStepsToGoLine(lang, 3), isNotEmpty);
        expect(glanceStepsToGoLine(lang, 1782), isNotEmpty);
        expect(glanceGoalReached(lang), isNotEmpty);
        expect(
          glanceStatusLine(
            language: lang,
            steps: 100,
            goal: 8000,
            isRestDay: true,
          ),
          StreakText.restDay(lang),
        );
        final toGo = build(language: lang, steps: 4218);
        expect(toGo.statusKind, GlanceStatusKind.toGo);
        expect(toGo.statusLine, glanceStepsToGoLine(lang, 3782));
        final reached = build(language: lang, steps: 8000);
        expect(reached.statusLine, glanceGoalReached(lang));
        final rest = build(language: lang, steps: 10, restToday: true);
        expect(rest.statusLine, StreakText.restDay(lang));
      }
    });

    test('English, Slovak and Polish plurals', () {
      expect(glanceStepsToGoLine('en', 1), '1 step to go');
      expect(glanceStepsToGoLine('en', 2), '2 steps to go');
      expect(glanceStepsToGoLine('sk', 1), 'Ešte 1 krok');
      expect(glanceStepsToGoLine('sk', 3), 'Ešte 3 kroky');
      expect(glanceStepsToGoLine('sk', 5), 'Ešte 5 krokov');
      expect(glanceStepsToGoLine('pl', 1), 'Jeszcze 1 krok');
      expect(glanceStepsToGoLine('pl', 2), 'Jeszcze 2 kroki');
      expect(glanceStepsToGoLine('pl', 5), 'Jeszcze 5 kroków');
    });
  });

  group('throttling', () {
    final t0 = DateTime(2026, 10, 14, 8, 0);
    const id = '2026-10-14|8000|3|toGo|1|2|en|false';

    test('first push always allowed', () {
      expect(
        shouldPushGlance(
          now: t0,
          lastPush: null,
          lastIdentity: '',
          nextIdentity: id,
          lastSteps: -1,
          nextSteps: 100,
        ),
        isTrue,
      );
    });

    test('identical data is skipped', () {
      expect(
        shouldPushGlance(
          now: t0.add(const Duration(minutes: 5)),
          lastPush: t0,
          lastIdentity: id,
          nextIdentity: id,
          lastSteps: 100,
          nextSteps: 100,
        ),
        isFalse,
      );
    });

    test('count changes wait about a minute', () {
      expect(
        shouldPushGlance(
          now: t0.add(const Duration(seconds: 30)),
          lastPush: t0,
          lastIdentity: id,
          nextIdentity: id,
          lastSteps: 100,
          nextSteps: 140,
        ),
        isFalse,
      );
      expect(
        shouldPushGlance(
          now: t0.add(const Duration(minutes: 1)),
          lastPush: t0,
          lastIdentity: id,
          nextIdentity: id,
          lastSteps: 100,
          nextSteps: 140,
        ),
        isTrue,
      );
    });

    test('midnight, goal and streak push immediately', () {
      expect(
        shouldPushGlance(
          now: t0.add(const Duration(seconds: 10)),
          lastPush: t0,
          lastIdentity: id,
          nextIdentity: '2026-10-15|8000|3|toGo|1|2|en|false',
          lastSteps: 100,
          nextSteps: 0,
        ),
        isTrue,
      );
      expect(
        shouldPushGlance(
          now: t0.add(const Duration(seconds: 10)),
          lastPush: t0,
          lastIdentity: id,
          nextIdentity: '2026-10-14|9000|3|toGo|1|2|en|false',
          lastSteps: 100,
          nextSteps: 100,
        ),
        isTrue,
      );
      expect(
        shouldPushGlance(
          now: t0.add(const Duration(seconds: 10)),
          lastPush: t0,
          lastIdentity: id,
          nextIdentity: '2026-10-14|8000|4|goalReached|1|2|en|false',
          lastSteps: 7990,
          nextSteps: 8000,
        ),
        isTrue,
      );
    });
  });

  group('from store including a new calendar day', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('shows zero steps after midnight before the counter rolls', () async {
      await Store.instance.init();
      Store.instance.goal = 8000;
      Store.instance.todayDate = '2026-10-13';
      Store.instance.todaySteps = 6400;
      Store.instance.lookId = 'quiet_gold';
      Store.instance.language = 'en';
      final data = glanceDataFromStore(
        Store.instance,
        now: now,
        deviceLanguage: 'en',
      );
      expect(data.date, '2026-10-14');
      expect(data.steps, 0);
      expect(data.statusKind, GlanceStatusKind.toGo);
    });
  });
}
