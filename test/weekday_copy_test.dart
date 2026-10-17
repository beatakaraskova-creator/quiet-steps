import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/day_pick.dart';
import 'package:quiet_steps/l10n/greeting_lines.dart';
import 'package:quiet_steps/l10n/milestone_lines.dart';
import 'package:quiet_steps/l10n/postcard_text.dart';
import 'package:quiet_steps/l10n/reflection_lines.dart';
import 'package:quiet_steps/l10n/streak_text.dart';
import 'package:quiet_steps/l10n/walk_text.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/postcard.dart';
import 'package:quiet_steps/services/reflection.dart';
import 'package:quiet_steps/services/walks.dart';

final monday = DateTime(2026, 10, 19);
final wednesday = DateTime(2026, 10, 21);
final sunday = DateTime(2026, 10, 25);

void main() {
  test('weekdayIndex: Monday is 0, Sunday is 6, short lists wrap', () {
    expect(weekdayIndex(monday, 7), 0);
    expect(weekdayIndex(sunday, 7), 6);
    expect(weekdayIndex(sunday, 3), 0);
    expect(weekdayIndex(sunday, 7, offset: 1), 0);
    expect(weekdayIndex(monday, 0), 0);
  });

  test('every warm list has 7 lines in every language', () {
    for (final lang in supportedLanguages) {
      for (final style in milestoneLines[lang]!.values) {
        for (final lines in style.values) {
          expect(lines.length, 7, reason: lang);
        }
      }
      for (final m in [walkLines, reflectionClosings, postcardDayLines]) {
        for (final lines in m[lang]!.values) {
          expect(lines.length, 7, reason: lang);
        }
      }
      for (final style in [...greetingLines[lang]!.values, ...restDayLines[lang]!.values]) {
        for (final lines in style.values) {
          expect(lines.length, 7, reason: lang);
        }
      }
    }
  });

  test('pickers use the weekday', () {
    expect(
      pickMilestoneLine(language: 'sk', style: 'calm', milestone: '2500', day: monday),
      milestoneLines['sk']!['calm']!['2500']![0],
    );
    expect(
      pickWalkLine(language: 'de', mood: 'slow', day: sunday),
      walkLines['de']!['slow']![6],
    );
    expect(
      pickReflectionClosing(language: 'fr', group: 'met', day: wednesday),
      reflectionClosings['fr']!['met']![2],
    );
    expect(postcardClosingLine('it', 'some', day: sunday), postcardDayLines['it']!['some']![6]);
  });

  test('beyond lines move on with the repeat offset', () {
    final fired = <String>{'2500', '5000', '7500', 'goal'};
    expect(sameBucketFiredToday(fired, '10500'), 0);
    fired.add('10500');
    expect(sameBucketFiredToday(fired, '13000'), 1);
    expect(
      pickMilestoneLine(language: 'en', style: 'calm', milestone: '13000', day: wednesday, offset: 1),
      milestoneLines['en']!['calm']!['beyond']![3],
    );
    expect(sameBucketFiredToday({'35000', '40000'}, '45000'), 2);
  });

  test('greeting and rest-day line fall back to English', () {
    expect(greetingKeyFor(DateTime(2026, 10, 19, 8)), 'greeting_morning');
    expect(greetingKeyFor(DateTime(2026, 10, 19, 13)), 'greeting_afternoon');
    expect(greetingKeyFor(DateTime(2026, 10, 19, 2)), 'greeting_evening');
    expect(
      pickGreeting(language: 'zz', style: 'nope', now: DateTime(2026, 10, 25, 20)),
      greetingLines['en']!['calm']!['greeting_evening']![6],
    );
    expect(StreakText.restDayLine('xx', 'cheerful', monday), restDayLines['en']!['cheerful']!['rest_day']![0]);
    expect(StreakText.restDayLine('sk', 'calm', sunday), restDayLines['sk']!['calm']!['rest_day']![6]);
  });
}
