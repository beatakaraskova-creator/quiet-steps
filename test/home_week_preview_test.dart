import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiet_steps/l10n/streak_text.dart';
import 'package:quiet_steps/models/look_pack.dart';
import 'package:quiet_steps/services/step_math.dart';
import 'package:quiet_steps/widgets/week_strip.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('week strip shows streak, rest day and step count', (tester) async {
    await initializeDateFormatting('en');
    final pack = LookPack.quietGold;
    final today = DateTime(2026, 10, 14);
    final steps = <String, int>{
      todayKey(DateTime(2026, 10, 12)): 1200,
      todayKey(DateTime(2026, 10, 13)): 8100,
      todayKey(DateTime(2026, 10, 14)): 5400,
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: pack.bg,
          body: WeekStrip(
            stepsByDate: steps,
            goal: 8000,
            now: today,
            language: 'en',
            pack: pack,
            fontScale: 1,
            frosted: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('This week'), findsOneWidget);
    expect(find.text('1 good day'), findsOneWidget);
    expect(find.text('5,400 steps'), findsOneWidget);

    await tester.tap(find.text('Mon'));
    await tester.pumpAndSettle();
    expect(find.text('Rest day · 1,200 steps'), findsOneWidget);
  });

  testWidgets('fresh start copy when the streak has restarted', (tester) async {
    await initializeDateFormatting('en');
    final today = DateTime(2026, 10, 14);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeekStrip(
            stepsByDate: {
              todayKey(today): 400,
              todayKey(DateTime(2026, 10, 13)): 300,
              todayKey(DateTime(2026, 10, 12)): 200,
              todayKey(DateTime(2026, 10, 11)): 8000,
            },
            goal: 8000,
            now: today,
            language: 'en',
            pack: LookPack.quietGold,
            fontScale: 1,
            frosted: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(StreakText.freshStart('en')), findsOneWidget);
  });
}
