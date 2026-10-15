import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiet_steps/l10n/backup_text.dart';
import 'package:quiet_steps/l10n/easy_text.dart';
import 'package:quiet_steps/l10n/glance_text.dart';
import 'package:quiet_steps/l10n/milestone_lines.dart';
import 'package:quiet_steps/l10n/postcard_text.dart';
import 'package:quiet_steps/l10n/reflection_lines.dart';
import 'package:quiet_steps/l10n/streak_text.dart';
import 'package:quiet_steps/l10n/ui_text.dart';
import 'package:quiet_steps/l10n/walk_text.dart';
import 'package:quiet_steps/main.dart';
import 'package:quiet_steps/screens/history_screen.dart';
import 'package:quiet_steps/screens/home_screen.dart';
import 'package:quiet_steps/screens/language_picker_screen.dart';
import 'package:quiet_steps/screens/look_screen.dart';
import 'package:quiet_steps/screens/onboarding_screen.dart';
import 'package:quiet_steps/screens/settings_screen.dart';
import 'package:quiet_steps/services/app_locale.dart';
import 'package:quiet_steps/services/easy_mode.dart';
import 'package:quiet_steps/services/format.dart';
import 'package:quiet_steps/services/look.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _boot({
  bool onboardingDone = true,
  bool languagePicked = true,
  String language = 'en',
  bool easy = false,
  String deviceLanguage = 'en',
}) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_done': onboardingDone,
    'language_picked': languagePicked,
    'language': language,
    'goal': 8000,
    'today_steps': 4218,
    'today_date': '2026-10-15',
    'big_simple': easy,
    'counting': false,
    'evening_reflection': false,
  });
  await Store.instance.init();
  Store.instance.onboardingDone = onboardingDone;
  Store.instance.languagePicked = languagePicked;
  Store.instance.language = language;
  Store.instance.bigSimple = easy;
  Store.instance.counting = false;
  Store.instance.eveningReflection = false;
  AppLocale.instance.load(deviceLanguageCode: deviceLanguage);
  await Look.instance.load();
}

Future<void> _pumpApp(
  WidgetTester tester, {
  Size size = const Size(360, 640),
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
  await tester.pump();
}

Future<void> _pumpPage(
  WidgetTester tester,
  Widget page, {
  Size size = const Size(360, 640),
  Key? key,
  bool easy = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final scale = easy ? easyTextScale(1.0) : 1.0;
  await tester.pumpWidget(
    MediaQuery(
      key: key,
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(scale),
      ),
      child: MaterialApp(
        theme: Look.instance.theme,
        home: page,
      ),
    ),
  );
  await tester.pump();
}

void _expectKeys(Object? english, Object? other, String path) {
  if (english is Map) {
    expect(other, isA<Map>(), reason: path);
    final map = other as Map;
    for (final key in english.keys) {
      expect(map.containsKey(key), isTrue, reason: '$path missing $key');
      _expectKeys(english[key], map[key], '$path.$key');
    }
  } else if (english is List) {
    expect(other, isA<List>(), reason: path);
    expect((other as List), isNotEmpty, reason: path);
  } else if (english is String) {
    expect(other, isA<String>(), reason: path);
    expect((other as String).trim(), isNotEmpty, reason: path);
  }
}

final _quote = RegExp(r'''(['"])((?:\\.|[^\\])*?)\1''');

const _allowedPhrases = {
  'Quiet Steps',
  'QUIET STEPS',
  'Pictures/Quiet Steps',
  'Quiet gold',
  'Night moss',
  'Your colours',
};

List<String> _scanHardcoded(Directory root) {
  final hits = <String>[];
  final files = [
    File('${root.path}/main.dart'),
    ...Directory('${root.path}/screens').listSync().whereType<File>(),
    ...Directory('${root.path}/widgets').listSync().whereType<File>(),
    ...Directory('${root.path}/services').listSync().whereType<File>(),
  ];
  for (final file in files) {
    if (!file.path.endsWith('.dart')) continue;
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      final trimmed = line.trimLeft();
      if (trimmed.startsWith('//') ||
          trimmed.startsWith('import ') ||
          trimmed.startsWith('export ')) {
        continue;
      }
      final comment = line.indexOf('//');
      if (comment >= 0) line = line.substring(0, comment);
      for (final m in _quote.allMatches(line)) {
        var value = m.group(2)!;
        value = value.replaceAll(r"\'", "'").replaceAll(r'\"', '"');
        if (!value.contains(' ')) continue;
        if (!RegExp(r'[A-Za-z]{3,}').hasMatch(value)) continue;
        if (_allowedPhrases.contains(value)) continue;
        final words = value.split(RegExp(r'\s+'));
        if (words.length < 2) continue;
        if (!RegExp(r'^[A-Za-z]').hasMatch(value)) continue;
        final rel = file.path.replaceAll('\\', '/');
        hits.add('$rel:${i + 1}: $value');
      }
    }
  }
  return hits;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    for (final lang in supportedLanguages) {
      await initializeDateFormatting(lang);
    }
  });

  group('l10n completeness', () {
    test('every English key exists in all 8 languages', () {
      for (final lang in supportedLanguages) {
        _expectKeys(ui['en'], ui[lang], 'ui.$lang');
        _expectKeys(easyUi['en'], easyUi[lang], 'easyUi.$lang');
        _expectKeys(backupUi['en'], backupUi[lang], 'backupUi.$lang');
        _expectKeys(glanceUi['en'], glanceUi[lang], 'glanceUi.$lang');
        _expectKeys(glanceStatusGoal['en'], glanceStatusGoal[lang], 'glanceStatus.$lang');
        _expectKeys(glanceStepsToGo['en'], glanceStepsToGo[lang], 'glanceStepsToGo.$lang');
        _expectKeys(postcardUi['en'], postcardUi[lang], 'postcardUi.$lang');
        _expectKeys(postcardLines['en'], postcardLines[lang], 'postcardLines.$lang');
        _expectKeys(walkUi['en'], walkUi[lang], 'walkUi.$lang');
        _expectKeys(walkLines['en'], walkLines[lang], 'walkLines.$lang');
        _expectKeys(walkMoodLabels['en'], walkMoodLabels[lang], 'walkMood.$lang');
        _expectKeys(reflectionUi['en'], reflectionUi[lang], 'reflectionUi.$lang');
        _expectKeys(reflectionClosings['en'], reflectionClosings[lang], 'reflectionClosings.$lang');
        _expectKeys(milestoneLines['en'], milestoneLines[lang], 'milestoneLines.$lang');
        expect(StreakText.thisWeek(lang), isNotEmpty, reason: lang);
        expect(StreakText.restDay(lang), isNotEmpty, reason: lang);
        expect(StreakText.freshStart(lang), isNotEmpty, reason: lang);
        expect(StreakText.goodDays(lang, 1), isNotEmpty, reason: lang);
        expect(StreakText.goodDays(lang, 3), isNotEmpty, reason: lang);
        expect(StreakText.goodDays(lang, 5), isNotEmpty, reason: lang);
        expect(StreakText.steps(lang, 1), isNotEmpty, reason: lang);
        expect(StreakText.steps(lang, 5400), isNotEmpty, reason: lang);
        expect(StreakText.stepsWord(lang, 5400), isNotEmpty, reason: lang);
        expect(StreakText.steps(lang, 5400).contains(StreakText.stepsWord(lang, 5400)), isTrue);
        expect(languageLabels[lang], isNotEmpty, reason: lang);
      }
    });

    test('Android values-xx share the English string names', () {
      final en = File('android/app/src/main/res/values/strings.xml');
      expect(en.existsSync(), isTrue);
      final names = RegExp(r'name="([^"]+)"')
          .allMatches(en.readAsStringSync())
          .map((m) => m.group(1)!)
          .toSet();
      expect(names, isNotEmpty);
      for (final lang in supportedLanguages) {
        if (lang == 'en') continue;
        final file = File('android/app/src/main/res/values-$lang/strings.xml');
        expect(file.existsSync(), isTrue, reason: lang);
        final got = RegExp(r'name="([^"]+)"')
            .allMatches(file.readAsStringSync())
            .map((m) => m.group(1)!)
            .toSet();
        expect(got, names, reason: lang);
      }
    });
  });

  group('number formats', () {
    test('thousands grouping follows the language', () {
      expect(formatCount(10000, 'en'), '10,000');
      expect(formatCount(10000, 'de'), '10.000');
      expect(formatCount(10000, 'sk'), isNot('10,000'));
      expect(glanceFormatNumber(4000, 'en'), '4,000');
      expect(StreakText.steps('en', 5400), '5,400 steps');
    });

    test('decimals use a comma in sk/cs/pl/de/es/fr/it and a point in en', () {
      expect(formatDecimal(4.99, 'en'), '4.99');
      for (final lang in ['sk', 'cs', 'pl', 'de', 'es', 'fr', 'it']) {
        expect(formatDecimal(4.99, lang), '4,99', reason: lang);
      }
    });
  });

  group('language picker', () {
    test('suggested language uses the phone when supported', () {
      expect(suggestedLanguage(deviceLanguageCode: 'sk'), 'sk');
      expect(suggestedLanguage(deviceLanguageCode: 'de'), 'de');
      expect(suggestedLanguage(deviceLanguageCode: 'ja'), 'en');
      expect(suggestedLanguage(deviceLanguageCode: 'pt-BR'), 'en');
    });

    testWidgets('first launch shows the picker before welcome', (tester) async {
      await _boot(onboardingDone: false, languagePicked: false, language: 'auto');
      await _pumpApp(tester, size: const Size(400, 1400));
      expect(find.byType(LanguagePickerScreen), findsOneWidget);
      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(HomeScreen), findsNothing);
      for (final code in supportedLanguages) {
        expect(find.text(languageLabels[code]!), findsOneWidget);
      }
    });

    testWidgets('pre-selects the phone language', (tester) async {
      tester.platformDispatcher.localeTestValue = const Locale('pl');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);
      await _boot(
        onboardingDone: false,
        languagePicked: false,
        language: 'auto',
        deviceLanguage: 'pl',
      );
      await _pumpApp(tester, size: const Size(400, 1400));
      final tile = tester.widget<InkWell>(find.byKey(const ValueKey('lang-pl')));
      expect(tile.key, const ValueKey('lang-pl'));
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Continue saves and opens welcome in that language', (tester) async {
      await _boot(onboardingDone: false, languagePicked: false, language: 'auto');
      await _pumpApp(tester, size: const Size(400, 1400));
      await tester.tap(find.byKey(const ValueKey('lang-sk')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('language-continue')));
      await tester.pumpAndSettle();
      expect(Store.instance.language, 'sk');
      expect(Store.instance.languagePicked, isTrue);
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text(uiLine('sk', 'skip')), findsOneWidget);
      expect(find.text(uiLine('sk', 'page1Body')), findsOneWidget);
    });

    testWidgets('existing users skip the picker', (tester) async {
      await _boot(onboardingDone: true, languagePicked: false);
      await _pumpApp(tester, size: const Size(400, 1400));
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LanguagePickerScreen), findsNothing);
    });

    testWidgets('Settings language applies without restart', (tester) async {
      await _boot(onboardingDone: true, language: 'en');
      await _pumpApp(tester, size: const Size(400, 1400));
      expect(find.text(uiLine('en', 'startCounting')), findsOneWidget);
      await tester.tap(find.byTooltip(uiLine('en', 'settings')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('settings-language')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('settings-lang-de')));
      await tester.tap(find.byKey(const ValueKey('settings-lang-de')));
      await tester.pumpAndSettle();
      expect(Store.instance.language, 'de');
      expect(currentLanguage(), 'de');
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text(uiLine('de', 'startCounting')), findsOneWidget);
    });
  });

  group('layout', () {
    testWidgets('no overflow on a small phone in all 8 languages', (tester) async {
      final overflows = <String>[];
      final old = FlutterError.onError;
      FlutterError.onError = (details) {
        final s = details.exceptionAsString();
        if (s.contains('overflowed')) {
          overflows.add(s.split('\n').first);
        } else {
          old?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = old);

      const phone = Size(360, 640);
      for (final easy in [false, true]) {
        for (final lang in supportedLanguages) {
          final tag = '$lang easy=$easy';
          await _boot(
            onboardingDone: false,
            languagePicked: false,
            language: lang,
            easy: easy,
          );
          await _pumpPage(
            tester,
            const LanguagePickerScreen(),
            size: phone,
            key: ValueKey('pick-$tag'),
            easy: easy,
          );
          expect(find.byType(LanguagePickerScreen), findsOneWidget, reason: tag);
          expect(tester.takeException(), isNull, reason: 'picker $tag');

          await _boot(
            onboardingDone: false,
            languagePicked: true,
            language: lang,
            easy: easy,
          );
          await _pumpPage(
            tester,
            const OnboardingScreen(),
            size: phone,
            key: ValueKey('onboard-$tag'),
            easy: easy,
          );
          expect(find.byType(OnboardingScreen), findsOneWidget, reason: tag);
          expect(tester.takeException(), isNull, reason: 'onboarding $tag');

          await _boot(
            onboardingDone: true,
            languagePicked: true,
            language: lang,
            easy: easy,
          );
          await _pumpPage(
            tester,
            const HomeScreen(),
            size: phone,
            key: ValueKey('home-$tag'),
            easy: easy,
          );
          expect(find.byType(HomeScreen), findsOneWidget, reason: tag);
          expect(tester.takeException(), isNull, reason: 'home $tag');

          await _pumpPage(
            tester,
            const SettingsScreen(),
            size: phone,
            key: ValueKey('settings-$tag'),
            easy: easy,
          );
          expect(tester.takeException(), isNull, reason: 'settings $tag');

          await _pumpPage(
            tester,
            const LookScreen(),
            size: phone,
            key: ValueKey('look-$tag'),
            easy: easy,
          );
          expect(tester.takeException(), isNull, reason: 'look $tag');

          await _pumpPage(
            tester,
            const HistoryScreen(),
            size: phone,
            key: ValueKey('history-$tag'),
            easy: easy,
          );
          expect(tester.takeException(), isNull, reason: 'history $tag');
        }
      }
      expect(overflows, isEmpty, reason: overflows.join('\n'));
    });
  });

  group('hard-coded copy', () {
    test('lib screens, widgets and services have no leftover English phrases', () {
      final hits = _scanHardcoded(Directory('lib'));
      expect(hits, isEmpty, reason: hits.join('\n'));
    });
  });
}
