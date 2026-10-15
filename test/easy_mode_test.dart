import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiet_steps/l10n/easy_text.dart';
import 'package:quiet_steps/main.dart';
import 'package:quiet_steps/models/look_pack.dart';
import 'package:quiet_steps/screens/home_screen.dart';
import 'package:quiet_steps/screens/onboarding_screen.dart';
import 'package:quiet_steps/services/easy_mode.dart';
import 'package:quiet_steps/services/look.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:quiet_steps/services/walks.dart';
import 'package:quiet_steps/widgets/week_strip.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _boot({
  bool easy = false,
  String language = 'en',
  bool onboardingDone = true,
}) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_done': onboardingDone,
    'goal': 8000,
    'today_steps': 4218,
    'today_date': '2026-10-15',
    'language': language,
    'big_simple': easy,
    'counting': false,
    'evening_reflection': false,
  });
  await Store.instance.init();
  Store.instance.onboardingDone = onboardingDone;
  Store.instance.language = language;
  Store.instance.bigSimple = easy;
  Store.instance.counting = false;
  Store.instance.eveningReflection = false;
  await Look.instance.load();
}

Future<void> _pumpApp(
  WidgetTester tester, {
  Size size = const Size(400, 1400),
  double textScale = 1.0,
  Key? key,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MediaQuery(
      key: key,
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
      ),
      child: const QuietStepsApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    for (final lang in supportedLanguages) {
      await initializeDateFormatting(lang);
    }
  });

  group('setting persists and toggles', () {
    test('defaults off and saves', () async {
      SharedPreferences.setMockInitialValues({});
      await Store.instance.init();
      expect(Store.instance.bigSimple, isFalse);
      Store.instance.bigSimple = true;
      expect(Store.instance.bigSimple, isTrue);
    });

    testWidgets('applies instantly without restart', (tester) async {
      await _boot(easy: false);
      await _pumpApp(tester);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-home')), findsNothing);
      expect(find.byTooltip('Look'), findsOneWidget);
      expect(find.text('Start counting'), findsOneWidget);

      await Look.instance.setBigSimple(true);
      await tester.pumpAndSettle();
      expect(Store.instance.bigSimple, isTrue);
      expect(find.byKey(const ValueKey('easy-home')), findsOneWidget);
      expect(find.text('Start counting'), findsNothing);

      await Look.instance.setBigSimple(false);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('easy-home')), findsNothing);
      expect(find.text('Start counting'), findsOneWidget);
    });
  });

  group('simplified Home', () {
    testWidgets('shows steps, status, walk and More', (tester) async {
      await _boot(easy: true);
      await _pumpApp(tester);

      expect(find.byKey(const ValueKey('easy-home')), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-steps')), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-status')), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-walk')), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-more')), findsOneWidget);
      expect(find.text(walkUiLine('en', 'start')), findsOneWidget);
      expect(find.text(easyUiLine('en', 'more')), findsOneWidget);
      expect(find.byType(WeekStrip), findsNothing);
      expect(find.byTooltip('Look'), findsNothing);
      expect(find.byTooltip('Settings'), findsNothing);
    });

    testWidgets('More lists week, reflection, journal, postcard and settings',
        (tester) async {
      await _boot(easy: true);
      await _pumpApp(tester);
      await tester.tap(find.byKey(const ValueKey('easy-more')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('easy-more-week')), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-more-reflection')), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-more-journal')), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-more-postcard')), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-more-settings')), findsOneWidget);
      expect(find.text(easyUiLine('en', 'thisWeek')), findsWidgets);
      expect(find.text(easyUiLine('en', 'settings')), findsOneWidget);
    });

    testWidgets('off mode keeps the usual Home', (tester) async {
      await _boot(easy: false);
      await _pumpApp(tester);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byKey(const ValueKey('easy-home')), findsNothing);
      expect(find.text('Start counting'), findsOneWidget);
      expect(find.byType(WeekStrip), findsOneWidget);
      expect(find.byTooltip('Look'), findsOneWidget);
      expect(find.byTooltip('History'), findsOneWidget);
      expect(find.byTooltip('Settings'), findsOneWidget);
    });
  });

  group('text scale and tap targets', () {
    test('boosts 1.4x and caps without shrinking below the system size', () {
      expect(easyTextScale(1.0), closeTo(1.4, 0.001));
      expect(easyTextScale(1.1), closeTo(1.54, 0.001));
      expect(easyTextScale(1.3), closeTo(1.7, 0.001));
      expect(easyTextScale(2.0), closeTo(2.0, 0.001));
    });

    test('accessible look meets WCAG AA', () {
      for (final pack in LookPack.builtIn) {
        final a = accessibleLook(pack);
        expect(
          contrastRatio(a.ink, a.bg),
          greaterThanOrEqualTo(4.5),
          reason: pack.id,
        );
        expect(
          contrastRatio(a.muted, a.bg),
          greaterThanOrEqualTo(4.5),
          reason: '${pack.id} muted',
        );
        expect(
          contrastRatio(a.accent, a.bg),
          greaterThanOrEqualTo(3.0),
          reason: '${pack.id} accent',
        );
      }
    });

    testWidgets('walk and More are at least 64dp', (tester) async {
      await _boot(easy: true);
      await _pumpApp(tester);
      expect(
        tester.getSize(find.byKey(const ValueKey('easy-walk'))).height,
        greaterThanOrEqualTo(easyTapMin),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('easy-more'))).height,
        greaterThanOrEqualTo(easyTapMin),
      );
    });
  });

  group('no overflow at largest system font', () {
    testWidgets('simplified Home in all 8 languages on a small phone',
        (tester) async {
      for (final lang in supportedLanguages) {
        await _boot(easy: true, language: lang);
        await _pumpApp(
          tester,
          size: const Size(360, 640),
          textScale: 2.0,
          key: ValueKey('easy-$lang'),
        );
        expect(tester.takeException(), isNull, reason: lang);
        expect(
          find.byKey(const ValueKey('easy-home')),
          findsOneWidget,
          reason: lang,
        );
        expect(find.text(easyUiLine(lang, 'more')), findsOneWidget, reason: lang);
        expect(
          find.text(walkUiLine(lang, 'start')),
          findsOneWidget,
          reason: lang,
        );
      }
    });
  });

  group('copy', () {
    test('all 8 languages have the new keys', () {
      const keys = [
        'title',
        'hint',
        'onboarding',
        'more',
        'thisWeek',
        'reflection',
        'journal',
        'postcard',
        'settings',
        'look',
        'history',
        'back',
        'startCounting',
        'pauseCounting',
        'resetToday',
      ];
      for (final lang in supportedLanguages) {
        expect(easyUi[lang], isNotNull, reason: lang);
        for (final key in keys) {
          expect(easyUiLine(lang, key), isNotEmpty, reason: '$lang $key');
        }
      }
    });
  });

  group('onboarding', () {
    testWidgets('offers Big and simple on the last page', (tester) async {
      await _boot(onboardingDone: false, easy: false);
      await _pumpApp(tester);
      expect(find.byType(OnboardingScreen), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(find.text(easyUiLine('en', 'title')), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
    });
  });
}
