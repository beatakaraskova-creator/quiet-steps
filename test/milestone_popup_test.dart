import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiet_steps/l10n/milestone_lines.dart';
import 'package:quiet_steps/l10n/popup_text.dart';
import 'package:quiet_steps/screens/home_screen.dart';
import 'package:quiet_steps/screens/settings_screen.dart';
import 'package:quiet_steps/services/app_locale.dart';
import 'package:quiet_steps/services/look.dart';
import 'package:quiet_steps/services/milestone_alerts.dart';
import 'package:quiet_steps/services/milestone_moments.dart';
import 'package:quiet_steps/services/milestone_sound.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/step_math.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:quiet_steps/widgets/milestone_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _day = '2026-10-15';
final _line = milestoneLines['en']!['calm']!['5000']![1];
final log = <String>[];

class _FakeChime implements ChimeOutput {
  @override
  Future<void> play() async => log.add('chime');
  @override
  Future<void> duck() async => log.add('duck');
  @override
  Future<void> stop() async => log.add('chimeStop');
}

PhoneSoundMode _mode = PhoneSoundMode.normal;

Future<void> _boot({
  String language = 'en',
  bool easy = false,
  bool speak = true,
  bool tune = true,
  Map<String, Object> extra = const {},
}) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_done': true,
    'language_picked': true,
    'language': language,
    'goal': 8000,
    'today_steps': 5120,
    'today_date': _day,
    'big_simple': easy,
    'counting': false,
    'evening_reflection': false,
    'speak_on': speak,
    'milestone_tune': tune,
    'quiet_hours': false,
    ...extra,
  });
  await Store.instance.init();
  AppLocale.instance.load(deviceLanguageCode: 'en');
  await Look.instance.load();
}

Future<void> _fire({bool live = false, String key = '5000'}) =>
    Store.instance.recordMilestone(
      date: _day,
      key: key,
      line: _line,
      language: 'en',
      live: live,
    );

Future<void> _pumpHome(WidgetTester tester) async {
  const size = Size(412, 915);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(theme: Look.instance.theme, home: const HomeScreen()),
  );
  await tester.pump(); // post-frame milestone check
  await tester.pump(const Duration(milliseconds: 500)); // fade in
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _closeAndDrain(WidgetTester tester) async {
  if (find.byType(MilestonePopup).evaluate().isNotEmpty) {
    await tester.tap(find.byKey(const ValueKey('popup-close')));
  }
  await tester.pump(const Duration(seconds: 3));
  await _settle(tester);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    for (final lang in supportedLanguages) {
      await initializeDateFormatting(lang);
    }
  });

  setUp(() {
    log.clear();
    _mode = PhoneSoundMode.normal;
    MilestoneSound.instance
      ..chime = _FakeChime()
      ..readMode = (() async => _mode)
      ..speak = ((m, s) async => log.add('voice'))
      ..stopVoice = (() async {})
      ..focus = ((hold) async {})
      ..voiceDelay = const Duration(milliseconds: 2500);
  });

  group('Home is clean again', () {
    for (final easy in [false, true]) {
      testWidgets('no Today card (${easy ? 'Big and simple' : 'standard'})', (tester) async {
        await _boot(easy: easy);
        await _fire();
        Store.instance.milestoneSeen = '$_day|5000';
        await _pumpHome(tester);
        expect(find.byKey(const ValueKey('home-milestone')), findsNothing);
        expect(find.byKey(const ValueKey('easy-milestone')), findsNothing);
        expect(find.text(_line), findsNothing);
        expect(find.byType(MilestonePopup), findsNothing);
      });
    }
  });

  group('pop-up', () {
    testWidgets('unseen milestone shows once on open, tune only (catch-up)', (tester) async {
      await _boot();
      await _fire(live: false);
      await _pumpHome(tester);
      expect(find.byType(MilestonePopup), findsOneWidget);
      expect(find.text(_line), findsOneWidget);
      expect(find.text('5,000 steps'), findsOneWidget);
      expect(Store.instance.milestoneSeen, '$_day|5000');
      await tester.pump(const Duration(seconds: 3));
      expect(log.where((e) => e == 'chime').length, 1);
      expect(log.contains('voice'), isFalse, reason: 'background already spoke it');
      await _closeAndDrain(tester);
      expect(find.byType(MilestonePopup), findsNothing);

      await tester.pumpWidget(const SizedBox());
      await _pumpHome(tester);
      expect(find.byType(MilestonePopup), findsNothing, reason: 'shown once only');
    });

    testWidgets('live milestone: tune, then voice 2.5 s in, ducked', (tester) async {
      await _boot();
      await _fire(live: true);
      await _pumpHome(tester);
      expect(find.byType(MilestonePopup), findsOneWidget);
      expect(log, ['chime']);
      await tester.pump(const Duration(milliseconds: 2600));
      expect(log, ['chime', 'duck', 'voice']);
      await _closeAndDrain(tester);
    });

    testWidgets('auto-closes after 30 seconds', (tester) async {
      await _boot();
      await _fire();
      await _pumpHome(tester);
      await tester.pump(const Duration(seconds: 29));
      expect(find.byType(MilestonePopup), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await _settle(tester);
      expect(find.byType(MilestonePopup), findsNothing);
    });

    testWidgets('Close button closes and stops the sound', (tester) async {
      await _boot();
      await _fire(live: true);
      await _pumpHome(tester);
      await tester.tap(find.byKey(const ValueKey('popup-close')));
      await _settle(tester);
      expect(find.byType(MilestonePopup), findsNothing);
      expect(log.contains('chimeStop'), isTrue);
      await tester.pump(const Duration(seconds: 3));
      expect(log.contains('voice'), isFalse, reason: 'closed before the voice');
    });

    testWidgets('tap outside the card closes', (tester) async {
      await _boot();
      await _fire();
      await _pumpHome(tester);
      await tester.tapAt(const Offset(12, 880));
      await _settle(tester);
      expect(find.byType(MilestonePopup), findsNothing);
      await tester.pump(const Duration(seconds: 3));
    });

    for (final easy in [false, true]) {
      testWidgets('ring tap re-opens today\'s line silently (${easy ? 'Big and simple' : 'standard'})', (tester) async {
        await _boot(easy: easy);
        await _fire();
        Store.instance.milestoneSeen = '$_day|5000';
        await _pumpHome(tester);
        expect(find.byType(MilestonePopup), findsNothing);
        await tester.tap(find.byKey(ValueKey(easy ? 'easy-ring-tap' : 'ring-tap')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(MilestonePopup), findsOneWidget);
        expect(find.text(_line), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
        expect(log, isEmpty, reason: 're-read is silent');
        await _closeAndDrain(tester);
      });
    }

    testWidgets('greetings never pop up; ring tap shows one before the first milestone', (tester) async {
      await _boot();
      await _pumpHome(tester);
      expect(find.byType(MilestonePopup), findsNothing);
      await tester.tap(find.byKey(const ValueKey('ring-tap')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MilestonePopup), findsOneWidget);
      expect(find.text(popupLine('en', 'today')), findsOneWidget);
      expect(log, isEmpty);
      await _closeAndDrain(tester);
    });

    testWidgets('waits while another screen is on top, shows when Home is back', (tester) async {
      await _boot();
      await _pumpHome(tester);
      final nav = tester.state<NavigatorState>(find.byType(Navigator));
      nav.push(MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('other'))));
      await _settle(tester);
      await _fire(live: true);
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(MilestonePopup), findsNothing);
      nav.pop();
      await _settle(tester);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MilestonePopup), findsOneWidget);
      await _closeAndDrain(tester);
    });

    testWidgets('yesterday\'s milestone is never shown', (tester) async {
      await _boot();
      await Store.instance.recordMilestone(
        date: '2026-10-14', key: '5000', line: _line, language: 'en', live: false);
      await _pumpHome(tester);
      expect(find.byType(MilestonePopup), findsNothing);
    });

    testWidgets('warm line uses the bundled serif and the look colours (custom, Big and simple)', (tester) async {
      await _boot(easy: true, extra: {
        'look_custom': true,
        'look_accent': 0xFF6FB7C9,
        'look_bg_color': 0xFF16202A,
      });
      await _fire();
      await _pumpHome(tester);
      final text = tester.widget<Text>(find.byKey(const ValueKey('popup-line')));
      expect(text.style?.fontFamily, milestoneSerif);
      final card = find.ancestor(
        of: find.byKey(const ValueKey('popup-line')),
        matching: find.byWidgetPredicate((w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == Look.instance.pack.card),
      );
      expect(card, findsOneWidget);
      await _closeAndDrain(tester);
    });

    testWidgets('Slovak label and Close', (tester) async {
      await _boot(language: 'sk');
      await _fire();
      await _pumpHome(tester);
      expect(find.text(popupLine('sk', 'close')), findsOneWidget);
      expect(find.text(milestonePopupLabel('sk', '5000')), findsOneWidget);
      await _closeAndDrain(tester);
    });
  });

  group('sound rules', () {
    test('quiet hours, silent and vibrate mute the tune and the voice', () {
      for (final m in [PhoneSoundMode.silent, PhoneSoundMode.vibrate]) {
        final p = milestoneSoundPlan(live: true, tuneOn: true, speakOn: true, quiet: false, mode: m);
        expect(p.any, isFalse);
      }
      final q = milestoneSoundPlan(live: true, tuneOn: true, speakOn: true, quiet: true, mode: PhoneSoundMode.normal);
      expect(q.any, isFalse);
    });

    test('tune setting and Speak messages are independent', () {
      var p = milestoneSoundPlan(live: true, tuneOn: false, speakOn: true, quiet: false, mode: PhoneSoundMode.normal);
      expect((p.chime, p.voice), (false, true));
      p = milestoneSoundPlan(live: true, tuneOn: true, speakOn: false, quiet: false, mode: PhoneSoundMode.unknown);
      expect((p.chime, p.voice), (true, false));
      p = milestoneSoundPlan(live: false, tuneOn: true, speakOn: true, quiet: false, mode: PhoneSoundMode.normal);
      expect((p.chime, p.voice), (true, false));
    });

    testWidgets('silent phone: pop-up shows, nothing plays', (tester) async {
      await _boot();
      _mode = PhoneSoundMode.silent;
      await _fire(live: true);
      await _pumpHome(tester);
      expect(find.byType(MilestonePopup), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(log, isEmpty);
      await _closeAndDrain(tester);
    });
  });

  group('no double speech', () {
    late int spoken;

    Future<void> bootAlerts() async {
      SharedPreferences.setMockInitialValues({
        'goal': 8000,
        'today_date': todayKey(),
        'today_steps': 5100,
        'speak_on': true,
        'quiet_hours': false,
        'milestone_on': true,
        'language': 'en',
      });
      await Store.instance.init();
      spoken = 0;
      MilestoneAlerts.instance.speak = ({
        required String text,
        required String language,
        required String speed,
        required String style,
        required String voiceKind,
      }) async =>
          spoken++;
    }

    tearDown(() => MilestoneAlerts.instance.onUiCommand('uiBackground'));

    test('app open: background stays quiet, the app speaks once', () async {
      await bootAlerts();
      MilestoneAlerts.instance.uiInForeground = () => true;
      final fired = await MilestoneAlerts.instance.onStepsUpdated(Store.instance, 4900, 5100);
      expect(fired, ['5000']);
      expect(spoken, 0);
      expect(Store.instance.latestMilestoneLive, isTrue);
      final m = pendingMilestoneMoment(Store.instance, language: 'en')!;
      expect(m.live, isTrue);
      MilestoneSound.instance.voiceDelay = Duration.zero;
      final plan = await MilestoneSound.instance.playFor(m, Store.instance);
      expect(plan.voice, isTrue);
      expect(log.where((e) => e == 'voice').length + spoken, 1);
    });

    test('app closed: background speaks, the catch-up pop-up does not', () async {
      await bootAlerts();
      MilestoneAlerts.instance.uiInForeground = () => false;
      await MilestoneAlerts.instance.onStepsUpdated(Store.instance, 4900, 5100);
      expect(spoken, 1);
      final m = pendingMilestoneMoment(Store.instance, language: 'en')!;
      expect(m.live, isFalse);
      final plan = await MilestoneSound.instance.playFor(m, Store.instance);
      expect(plan.voice, isFalse);
      expect(log.where((e) => e == 'voice').length + spoken, 1);
    });

    test('heartbeat from the app expires', () {
      final a = MilestoneAlerts.instance;
      a.onUiCommand('uiForeground');
      expect(a.uiInForeground(), isTrue);
      a.onUiCommand('uiForeground', now: DateTime.now().subtract(const Duration(minutes: 1)));
      expect(a.uiInForeground(), isFalse);
      a.onUiCommand('uiForeground');
      a.onUiCommand('uiBackground');
      expect(a.uiInForeground(), isFalse);
    });
  });

  group('Settings and text', () {
    testWidgets('Milestone tune toggle, on by default', (tester) async {
      await _boot();
      tester.view.physicalSize = const Size(412, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(theme: Look.instance.theme, home: const SettingsScreen()));
      await tester.pump();
      final tile = find.byKey(const ValueKey('settings-milestone-tune'));
      expect(tile, findsOneWidget);
      expect(tester.widget<SwitchListTile>(tile).value, isTrue);
      expect(find.text('Milestone tune'), findsOneWidget);
      await tester.tap(tile);
      await tester.pump();
      expect(Store.instance.milestoneTune, isFalse);
    });

    test('pop-up text exists in all 8 languages', () {
      for (final lang in supportedLanguages) {
        expect(popupText[lang]!.keys.toSet(), popupText['en']!.keys.toSet(), reason: lang);
        for (final v in popupText[lang]!.values) {
          expect(v.trim(), isNotEmpty, reason: lang);
        }
        if (lang != 'en') expect(popupText[lang]!['tune'], isNot(popupText['en']!['tune']));
      }
      expect(milestonePopupLabel('sk', '5000'), '5\u00a0000 krokov');
      expect(milestonePopupLabel('en', 'goal'), 'Daily goal');
      expect(milestonePopupLabel('de', '12500'), '12.500 Schritte');
    });
  });
}
