import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/ui_text.dart';
import 'package:quiet_steps/screens/credits_screen.dart';
import 'package:quiet_steps/services/app_locale.dart';
import 'package:quiet_steps/services/look.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _langs = ['en', 'sk', 'cs', 'pl', 'de', 'es', 'fr', 'it'];
const _keys = ['privacyTitle', 'privacyHint', 'privacyCopy', 'privacyCopied'];

Future<void> _boot(String language) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_done': true,
    'language_picked': true,
    'language': language,
    'goal': 8000,
    'today_steps': 4218,
    'today_date': '2026-10-15',
    'counting': false,
    'evening_reflection': false,
  });
  await Store.instance.init();
  Store.instance.onboardingDone = true;
  Store.instance.languagePicked = true;
  Store.instance.language = language;
  AppLocale.instance.load(deviceLanguageCode: 'en');
  await Look.instance.load();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('privacy policy URL is the published page', () {
    expect(privacyPolicyUrl, 'https://web.wainshop.com/quiet-steps-privacy');
  });

  test('privacy link text exists and is translated in all 8 languages', () {
    expect(supportedLanguages.toSet(), _langs.toSet());
    for (final lang in _langs) {
      for (final key in _keys) {
        final value = ui[lang]?[key];
        expect(value, isNotNull, reason: '$lang.$key');
        expect(value!.trim(), isNotEmpty, reason: '$lang.$key');
        if (lang != 'en') {
          expect(value, isNot(ui['en']![key]), reason: '$lang.$key');
        }
      }
    }
    expect(ui['en']!['privacyTitle'], 'Privacy policy');
    expect(ui['sk']!['privacyTitle'], 'Zásady ochrany súkromia');
  });

  for (final lang in _langs) {
    testWidgets('About screen shows the privacy policy link ($lang)',
        (tester) async {
      await _boot(lang);
      tester.view.physicalSize = const Size(360, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(theme: Look.instance.theme, home: const CreditsScreen()),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey('credits-privacy')), findsOneWidget);
      expect(find.text(uiLine(lang, 'privacyTitle')), findsOneWidget);
      expect(find.text(uiLine(lang, 'privacyHint')), findsOneWidget);
      expect(find.text(uiLine(lang, 'privacyCopy')), findsOneWidget);
      final url = tester.widget<SelectableText>(
        find.byKey(const ValueKey('credits-privacy-url')),
      );
      expect(url.data, privacyPolicyUrl);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Copy link puts the URL on the clipboard', (tester) async {
    await _boot('sk');
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: Look.instance.theme, home: const CreditsScreen()),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('credits-privacy-copy')));
    await tester.pump();
    expect(copied, privacyPolicyUrl);
    expect(find.text(uiLine('sk', 'privacyCopied')), findsOneWidget);
  });

  test('Android manifest stays Play-safe and offline', () {
    final main = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    final declared = RegExp(
      r'<uses-permission\s+android:name="android\.permission\.([A-Z_]+)"([^>]*)>',
    ).allMatches(main).where((m) => !m.group(2)!.contains('tools:node="remove"'))
        .map((m) => m.group(1))
        .toSet();
    for (final banned in [
      'INTERNET',
      'READ_MEDIA_IMAGES',
      'READ_MEDIA_VIDEO',
      'READ_EXTERNAL_STORAGE',
      'MANAGE_EXTERNAL_STORAGE',
      'SCHEDULE_EXACT_ALARM',
      'USE_EXACT_ALARM',
      'REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    ]) {
      expect(declared, isNot(contains(banned)), reason: banned);
    }
    expect(main, contains('android:foregroundServiceType="health"'));
    expect(declared, contains('FOREGROUND_SERVICE_HEALTH'));
    expect(declared, contains('ACTIVITY_RECOGNITION'));
    final release = File('android/app/src/release/AndroidManifest.xml')
        .readAsStringSync();
    expect(
      release,
      contains(
        '<uses-permission android:name="android.permission.INTERNET" tools:node="remove" />',
      ),
    );
  });

  test('version is 1.0.3+4', () {
    final pubspec = File('pubspec.yaml').readAsStringSync().replaceAll('\r\n', '\n');
    expect(pubspec, contains('\nversion: 1.0.3+4\n'));
  });
}
