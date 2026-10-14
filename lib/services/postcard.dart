import '../l10n/postcard_text.dart';
import '../models/walk_entry.dart';
import 'step_math.dart';
import 'streaks.dart';

enum PostcardMark { none, gold, rest, muted }

class PostcardDay {
  const PostcardDay({required this.day, required this.mark, required this.steps});

  final int day;
  final PostcardMark mark;
  final int steps;
}

class PostcardData {
  const PostcardData({
    required this.year,
    required this.month,
    required this.totalSteps,
    required this.goodDays,
    required this.bestDaySteps,
    required this.walkCount,
    required this.elapsedDays,
    required this.firstWeekday,
    required this.days,
    required this.lineGroup,
  });

  final int year;
  final int month;
  final int totalSteps;
  final int goodDays;
  final int bestDaySteps;
  final int walkCount;
  final int elapsedDays;
  /// 1 = Monday … 7 = Sunday, matching DateTime.weekday.
  final int firstWeekday;
  final List<PostcardDay> days;
  final String lineGroup;
}

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

DateTime monthStart(DateTime d) => DateTime(d.year, d.month, 1);

DateTime prevMonth(DateTime d) => DateTime(d.year, d.month - 1, 1);

DateTime nextMonth(DateTime d) => DateTime(d.year, d.month + 1, 1);

bool canGoPrevMonth(DateTime view, DateTime earliest) {
  return monthStart(view).isAfter(monthStart(earliest));
}

bool canGoNextMonth(DateTime view, DateTime latest) {
  return monthStart(view).isBefore(monthStart(latest));
}

DateTime earliestPostcardMonth({
  required Iterable<String> dayKeys,
  required Iterable<String> walkIsos,
  required DateTime now,
}) {
  var earliest = monthStart(now);
  void consider(DateTime d) {
    final m = monthStart(d);
    if (m.isBefore(earliest)) earliest = m;
  }

  for (final k in dayKeys) {
    final d = DateTime.tryParse(k);
    if (d != null) consider(d);
  }
  for (final k in walkIsos) {
    final d = DateTime.tryParse(k);
    if (d != null) consider(d.toLocal());
  }
  return earliest;
}

int walksInMonth(List<WalkEntry> walks, int year, int month) {
  var n = 0;
  for (final w in walks) {
    final raw = w.endedAt.isNotEmpty ? w.endedAt : w.startedAt;
    final d = DateTime.tryParse(raw);
    if (d == null) continue;
    final local = d.toLocal();
    if (local.year == year && local.month == month) n++;
  }
  return n;
}

/// mostly: at least half of elapsed days met the goal.
/// some: at least one good day, but fewer than half.
/// quiet: no good days.
String postcardLineGroup({required int goodDays, required int elapsedDays}) {
  if (goodDays <= 0 || elapsedDays <= 0) return 'quiet';
  if (goodDays * 2 >= elapsedDays) return 'mostly';
  return 'some';
}

String postcardUiLine(String language, String key) {
  final lang = postcardUi.containsKey(language) ? language : 'en';
  return postcardUi[lang]?[key] ?? postcardUi['en']?[key] ?? key;
}

String postcardClosingLine(String language, String group) {
  final lang = postcardLines.containsKey(language) ? language : 'en';
  return postcardLines[lang]?[group] ??
      postcardLines['en']?[group] ??
      postcardLines['en']!['quiet']!;
}

String postcardWalksLabel(String language, int n) {
  final lang = postcardUi.containsKey(language) ? language : 'en';
  final forms = postcardUi[lang] ?? postcardUi['en']!;
  final abs = n.abs();
  String key;
  switch (lang) {
    case 'sk':
    case 'cs':
    case 'pl':
      if (abs == 1) {
        key = 'walksOne';
      } else if (abs >= 2 && abs <= 4) {
        key = forms.containsKey('walksFew') ? 'walksFew' : 'walksOther';
      } else {
        key = 'walksOther';
      }
      break;
    default:
      key = abs == 1 ? 'walksOne' : 'walksOther';
  }
  final template = forms[key] ?? forms['walksOther'] ?? postcardUi['en']!['walksOther']!;
  return template.replaceAll('{n}', '$n');
}

PostcardData buildPostcard({
  required int year,
  required int month,
  required Map<String, int> stepsByDate,
  required int goal,
  required DateTime now,
  required List<WalkEntry> walks,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final lastDay = daysInMonth(year, month);
  final first = DateTime(year, month, 1);

  DateTime? oldest;
  for (final key in stepsByDate.keys) {
    final d = DateTime.tryParse(key);
    if (d == null) continue;
    final day = DateTime(d.year, d.month, d.day);
    if (oldest == null || day.isBefore(oldest)) oldest = day;
  }

  final lastElapsed = DateTime(year, month, lastDay);
  final asOf = lastElapsed.isAfter(today) ? today : lastElapsed;
  final rest = computeStreak(
    stepsByDate: stepsByDate,
    goal: goal,
    now: asOf,
  ).restDates;

  var total = 0;
  var good = 0;
  var best = 0;
  var elapsed = 0;
  final days = <PostcardDay>[];

  for (var d = 1; d <= lastDay; d++) {
    final date = DateTime(year, month, d);
    final key = todayKey(date);
    final steps = stepsByDate[key] ?? 0;
    final future = date.isAfter(today);
    if (!future) elapsed++;
    total += future ? 0 : steps;
    if (!future && goal > 0 && steps >= goal) good++;
    if (!future && steps > best) best = steps;

    PostcardMark mark;
    if (future) {
      mark = PostcardMark.none;
    } else if (oldest != null && date.isBefore(oldest) && steps <= 0) {
      mark = PostcardMark.none;
    } else if (goal > 0 && steps >= goal) {
      mark = PostcardMark.gold;
    } else if (rest.contains(key)) {
      mark = PostcardMark.rest;
    } else {
      mark = PostcardMark.muted;
    }
    days.add(PostcardDay(day: d, mark: mark, steps: steps));
  }

  return PostcardData(
    year: year,
    month: month,
    totalSteps: total,
    goodDays: good,
    bestDaySteps: best,
    walkCount: walksInMonth(walks, year, month),
    elapsedDays: elapsed,
    firstWeekday: first.weekday,
    days: days,
    lineGroup: postcardLineGroup(goodDays: good, elapsedDays: elapsed),
  );
}
