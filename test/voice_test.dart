import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/spoken_catalog.dart';
import 'package:quiet_steps/l10n/ui_text.dart';
import 'package:quiet_steps/screens/credits_screen.dart';
import 'package:quiet_steps/screens/settings_screen.dart';
import 'package:quiet_steps/services/app_locale.dart';
import 'package:quiet_steps/services/look.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _boot({String language = 'en'}) async {
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

  test('voice kind defaults to female and persists', () async {
    SharedPreferences.setMockInitialValues({});
    final store = Store.instance;
    await store.init();
    expect(store.voiceKind, 'female');
    store.voiceKind = 'male';
    expect(store.voiceKind, 'male');
    store.voiceKind = 'phone';
    expect(store.voiceKind, 'phone');
    store.voiceKind = 'nope';
    expect(store.voiceKind, 'female');
  });

  test('clip path matches language and voice', () {
    expect(
      voiceClipAsset('en', 'female', 'voice_sample'),
      'assets/voices/en/female/voice_sample.ogg',
    );
    expect(
      voiceClipAsset('sk', 'male', 'walk_move_0'),
      'assets/voices/sk/male/walk_move_0.ogg',
    );
    expect(
      spokenIdForText('en', 'A gentle start. 2,500 steps.'),
      'milestone_calm_2500_0',
    );
    expect(
      spokenIdForText('en', 'Thank you for taking this time for yourself.'),
      'walk_gratitude_0',
    );
    expect(
      clipAssetForSpeak(
        language: 'en',
        voiceKind: 'female',
        text: 'A gentle start. 2,500 steps.',
      ),
      'assets/voices/en/female/milestone_calm_2500_0.ogg',
    );
    expect(
      clipAssetForSpeak(
        language: 'de',
        voiceKind: 'male',
        text: voiceSampleLine('de'),
      ),
      'assets/voices/de/male/voice_sample.ogg',
    );
  });

  test('phone voice and missing clips fall back to TTS', () {
    expect(
      clipAssetForSpeak(
        language: 'en',
        voiceKind: 'phone',
        text: 'A gentle start. 2,500 steps.',
      ),
      isNull,
    );
    expect(
      clipAssetForSpeak(
        language: 'en',
        voiceKind: 'female',
        text: 'A gentle start. 2,500 steps.',
        exists: (_) => false,
      ),
      isNull,
    );
    expect(
      clipAssetForSpeak(
        language: 'en',
        voiceKind: 'female',
        text: 'no matching spoken line at all',
      ),
      isNull,
    );
  });

  test('reflection spoken text maps to the closing clip', () {
    expect(
      spokenIdForText(
        'en',
        'Today you walked 4,218 steps. You reached your goal today. Let the evening be easy. 3 good days.',
      ),
      'reflection_met_0',
    );
  });

  test('every spoken line has a clip for every language and voice', () {
    final missing = <String>[];
    for (final lang in supportedLanguages) {
      final lines = spokenLinesFor(lang);
      expect(lines, isNotEmpty, reason: lang);
      expect(lines.length, spokenLinesFor('en').length, reason: lang);
      for (final voice in voiceGenders) {
        for (final line in lines) {
          final file = File('assets/voices/$lang/$voice/${line.id}.ogg');
          if (!file.existsSync() || file.lengthSync() < 200) {
            missing.add(file.path);
          }
        }
      }
    }
    expect(missing, isEmpty, reason: 'missing ${missing.length}: ${missing.take(12).join(', ')}');
  });

  testWidgets('settings voice chips and credits are on screen', (tester) async {
    await _boot();
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: Look.instance.theme,
        home: const SettingsScreen(),
      ),
    );
    await tester.pump();
    expect(find.text(uiLine('en', 'voice')), findsWidgets);
    expect(find.text(uiLine('en', 'voiceFemale')), findsOneWidget);
    expect(find.text(uiLine('en', 'voiceMale')), findsOneWidget);
    expect(find.text(uiLine('en', 'voicePhone')), findsOneWidget);
    expect(find.byKey(const ValueKey('voice-play-sample')), findsOneWidget);
    expect(find.byKey(const ValueKey('settings-about')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('voice-kind-male')));
    await tester.pump();
    expect(Store.instance.voiceKind, 'male');
  });

  testWidgets('about screen lists the voices', (tester) async {
    await _boot();
    await tester.pumpWidget(
      MaterialApp(
        theme: Look.instance.theme,
        home: const CreditsScreen(),
      ),
    );
    await tester.pump();
    expect(find.text(uiLine('en', 'aboutTitle')), findsWidgets);
    expect(find.textContaining('cori'), findsOneWidget);
    expect(find.textContaining('rhasspy'), findsOneWidget);
  });
}
