import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiet_steps/l10n/glance_text.dart';
import 'package:quiet_steps/models/look_pack.dart';
import 'package:quiet_steps/screens/home_screen.dart';
import 'package:quiet_steps/screens/settings_screen.dart';
import 'package:quiet_steps/services/app_locale.dart';
import 'package:quiet_steps/services/easy_mode.dart';
import 'package:quiet_steps/services/format.dart';
import 'package:quiet_steps/services/look.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/reflection.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:quiet_steps/widgets/step_ring.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _boot({
  String language = 'en',
  int steps = 4218,
  int goal = 8000,
  bool easy = false,
}) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_done': true,
    'language_picked': true,
    'language': language,
    'goal': goal,
    'today_steps': steps,
    'today_date': '2026-10-15',
    'big_simple': easy,
    'counting': false,
    'evening_reflection': false,
    'height_cm': 170,
  });
  await Store.instance.init();
  Store.instance.onboardingDone = true;
  Store.instance.languagePicked = true;
  Store.instance.language = language;
  Store.instance.bigSimple = easy;
  Store.instance.counting = false;
  Store.instance.eveningReflection = false;
  AppLocale.instance.load(deviceLanguageCode: 'en');
  await Look.instance.load();
}

Future<void> _pumpPage(
  WidgetTester tester,
  Widget page, {
  Size size = const Size(400, 1400),
  bool disableAnimations = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size,
        disableAnimations: disableAnimations,
      ),
      child: MaterialApp(
        theme: Look.instance.theme,
        home: page,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    for (final lang in supportedLanguages) {
      await initializeDateFormatting(lang);
    }
  });

  group('decimals', () {
    test('km uses the language decimal separator', () {
      expect(formatDecimal(4.99, 'en'), '4.99');
      for (final lang in ['sk', 'cs', 'pl', 'de', 'es', 'fr', 'it']) {
        expect(formatDecimal(4.99, lang), '4,99', reason: lang);
      }
    });
  });

  group('settings', () {
    test('reflection time label exists in all 8 languages', () {
      for (final lang in supportedLanguages) {
        expect(reflectionUiLine(lang, 'setting'), isNotEmpty, reason: lang);
        expect(reflectionUiLine(lang, 'reflectionTime'), isNotEmpty, reason: lang);
        expect(
          reflectionUiLine(lang, 'reflectionTime'),
          isNot(reflectionUiLine(lang, 'setting')),
          reason: lang,
        );
      }
      expect(reflectionUiLine('en', 'reflectionTime'), 'Reflection time');
      expect(reflectionUiLine('en', 'setting'), 'Evening reflection');
    });

    testWidgets('settings shows Evening reflection and Reflection time', (
      tester,
    ) async {
      await _boot();
      await _pumpPage(tester, const SettingsScreen());
      expect(find.text('Evening reflection'), findsOneWidget);
      expect(find.text('Reflection time'), findsOneWidget);
      expect(find.byKey(const ValueKey('settings-reflection-time')), findsOneWidget);
    });
  });

  group('switch contrast', () {
    test('on and off states meet WCAG AA in every look', () {
      final packs = <LookPack>[
        ...LookPack.builtIn,
        LookPack.custom(bg: const Color(0xFF141412), accent: const Color(0xFFC4A574)),
        LookPack.custom(bg: const Color(0xFFF4EFE6), accent: const Color(0xFF8B5E3C)),
      ];
      for (final pack in packs) {
        expect(
          contrastRatio(switchOnThumb(pack), pack.accent),
          greaterThanOrEqualTo(4.5),
          reason: '${pack.id} on thumb',
        );
        expect(
          contrastRatio(switchOffThumb(pack), pack.card),
          greaterThanOrEqualTo(4.5),
          reason: '${pack.id} off thumb',
        );
        expect(
          contrastRatio(switchOffOutline(pack), pack.card),
          greaterThanOrEqualTo(3.0),
          reason: '${pack.id} off outline',
        );
      }
    });
  });

  group('home copy', () {
    testWidgets('status becomes Goal reached when the daily goal is met', (
      tester,
    ) async {
      await _boot(steps: 8000, goal: 8000);
      await _pumpPage(tester, const HomeScreen());
      expect(find.text(glanceGoalReached('en')), findsOneWidget);
    });

    testWidgets('km uses a comma in Slovak', (tester) async {
      await _boot(language: 'sk', steps: 4218);
      await _pumpPage(tester, const HomeScreen());
      final km = formatDecimal(Store.instance.kmToday, 'sk');
      expect(km.contains(','), isTrue);
      expect(find.text(km), findsOneWidget);
    });
  });

  group('app bar', () {
    test('theme keeps the page colour when scrolled', () {
      final theme = Look.instance.theme;
      expect(theme.appBarTheme.scrolledUnderElevation, 0);
      expect(theme.appBarTheme.surfaceTintColor, Colors.transparent);
      expect(theme.appBarTheme.backgroundColor, Look.instance.pack.bg);
    });
  });

  group('step ring motion', () {
    testWidgets('fill animates when the system allows motion', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(400, 800)),
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: StepRing(
                  steps: 4000,
                  goal: 8000,
                  track: Color(0xFF2C2C28),
                  accent: Color(0xFFC4A574),
                  child: SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('skips fill, pulse and celebration when animations are off', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            size: Size(400, 800),
            disableAnimations: true,
          ),
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: StepRing(
                  steps: 2000,
                  goal: 8000,
                  track: Color(0xFF2C2C28),
                  accent: Color(0xFFC4A574),
                  child: SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            size: Size(400, 800),
            disableAnimations: true,
          ),
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: StepRing(
                  steps: 8000,
                  goal: 8000,
                  track: Color(0xFF2C2C28),
                  accent: Color(0xFFC4A574),
                  child: SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
