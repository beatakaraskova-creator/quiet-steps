import '../l10n/day_pick.dart';
import '../l10n/milestone_lines.dart';

const supportedLanguages = ['en', 'sk', 'cs', 'pl', 'de', 'es', 'fr', 'it'];

const languageOptions = [
  'auto',
  'en',
  'sk',
  'cs',
  'pl',
  'de',
  'es',
  'fr',
  'it',
];

const languageLabels = {
  'auto': 'Automatic',
  'en': 'English',
  'sk': 'Slovenčina',
  'cs': 'Čeština',
  'pl': 'Polski',
  'de': 'Deutsch',
  'es': 'Español',
  'fr': 'Français',
  'it': 'Italiano',
};

const ttsLocales = {
  'en': 'en-US',
  'sk': 'sk-SK',
  'cs': 'cs-CZ',
  'pl': 'pl-PL',
  'de': 'de-DE',
  'es': 'es-ES',
  'fr': 'fr-FR',
  'it': 'it-IT',
};

const milestoneThresholds = [2500, 5000, 7500];

/// Round-number celebrations after the goal. They replace a nearby regular tick.
const roundNumberSpecials = [10000, 15000, 20000, 25000, 30000];

/// No two beyond-goal messages within this many steps (inclusive).
const beyondGoalMinGap = 1000;

const _beyondUntil = 20000;
const _beyondThenEvery = 5000;
const _beyondThenFrom = 25000;

/// Catalog key for a fired milestone id (`2500`, `goal`, `10000`, `35000`, …).
String milestoneLineBucket(String milestone) {
  switch (milestone) {
    case '2500':
    case '5000':
    case '7500':
    case 'goal':
    case 'beyond':
    case 'round_10000':
    case 'round_15000':
    case 'round_20000':
    case 'round_25000':
    case 'round_30000':
    case 'care_30k':
      return milestone;
  }
  final n = int.tryParse(milestone);
  if (n == null) return milestone;
  if (n == 10000) return 'round_10000';
  if (n == 15000) return 'round_15000';
  if (n == 20000) return 'round_20000';
  if (n == 25000) return 'round_25000';
  if (n == 30000) return 'round_30000';
  if (n >= 30000) return 'care_30k';
  if (n >= 20000) return 'round_20000';
  return 'beyond';
}

bool _withinGap(int a, int b) => (a - b).abs() <= beyondGoalMinGap;

/// Step counts after the goal that earn a message.
///
/// Every 2,500 above [goal] while that tick is at most 20,000, then every
/// 5,000 from 25,000. Round numbers 10k–30k replace a regular tick when they
/// fall within [beyondGoalMinGap] steps. Ticks within that gap of the goal
/// are dropped so the goal line stands alone.
List<int> beyondGoalThresholds(int goal, {int upTo = 100000}) {
  if (goal <= 0) return const [];
  final cap = upTo < goal ? goal : upTo;

  final regular = <int>[];
  for (var n = goal + 2500; n <= _beyondUntil && n <= cap; n += 2500) {
    regular.add(n);
  }
  for (var n = _beyondThenFrom; n <= cap; n += _beyondThenEvery) {
    if (n > goal) regular.add(n);
  }

  final specials = [
    for (final s in roundNumberSpecials)
      if (s > goal && s <= cap && !_withinGap(s, goal)) s,
  ];

  final kept = <int>[...specials];
  for (final r in regular) {
    if (_withinGap(r, goal)) continue;
    if (specials.any((s) => _withinGap(s, r))) continue;
    kept.add(r);
  }
  kept.sort();
  return kept;
}

/// Resolve a stored language setting to a supported code.
/// Unknown phone languages fall back to English.
String resolveLanguage({
  required String stored,
  required String deviceLanguageCode,
}) {
  final raw = stored.trim().toLowerCase();
  final code = (raw.isEmpty || raw == 'auto')
      ? deviceLanguageCode.toLowerCase().split(RegExp(r'[-_]')).first
      : raw.split(RegExp(r'[-_]')).first;
  if (supportedLanguages.contains(code)) return code;
  return 'en';
}

/// Pick one line from `milestoneLines[language][style][milestone]` by weekday
/// (index 0 = Monday). [day] is the step-day the milestone belongs to and
/// [offset] is [sameBucketFiredToday] for moments that repeat within a day.
/// [nextInt] is a test hook and wins when given.
/// Unknown language falls back to English.
String pickMilestoneLine({
  required String language,
  required String style,
  required String milestone,
  DateTime? day,
  int offset = 0,
  int Function(int max)? nextInt,
}) {
  final langKey = milestoneLines.containsKey(language) ? language : 'en';
  final langMap = milestoneLines[langKey] ?? milestoneLines['en']!;
  final styleKey = langMap.containsKey(style) ? style : 'calm';
  final bucket = milestoneLineBucket(milestone);
  var lines = langMap[styleKey]?[bucket];
  if (lines == null || lines.isEmpty) {
    lines = milestoneLines['en']?[styleKey]?[bucket] ??
        milestoneLines['en']?['calm']?[bucket];
  }
  if (lines == null || lines.isEmpty) return '';
  if (nextInt != null) {
    return lines[nextInt(lines.length).clamp(0, lines.length - 1)];
  }
  return lines[weekdayIndex(day ?? DateTime.now(), lines.length, offset: offset)];
}

/// How many milestones already fired today map to the same line bucket as
/// [key] (`beyond`, `care_30k` and off-round 20k ticks can fire more than once).
int sameBucketFiredToday(Iterable<String> firedToday, String key) {
  final bucket = milestoneLineBucket(key);
  return firedToday.where((k) => k != key && milestoneLineBucket(k) == bucket).length;
}

/// Milestones that were just crossed and have not fired today.
/// Any fixed milestone at or above [goal] is skipped so the goal line is used.
List<String> newlyCrossedMilestones({
  required int previousSteps,
  required int currentSteps,
  required int goal,
  required Set<String> alreadyFired,
}) {
  if (currentSteps <= previousSteps) return [];
  final out = <String>[];
  for (final m in milestoneThresholds) {
    if (goal > 0 && m >= goal) continue;
    final key = '$m';
    if (previousSteps < m &&
        currentSteps >= m &&
        !alreadyFired.contains(key)) {
      out.add(key);
    }
  }
  if (goal > 0 &&
      previousSteps < goal &&
      currentSteps >= goal &&
      !alreadyFired.contains('goal')) {
    out.add('goal');
  }
  for (final m in beyondGoalThresholds(goal, upTo: currentSteps)) {
    final key = '$m';
    if (previousSteps < m &&
        currentSteps >= m &&
        !alreadyFired.contains(key)) {
      out.add(key);
    }
  }
  return out;
}

int minutesFromHm(String hm) {
  final p = hm.split(':');
  if (p.length < 2) return 0;
  final h = int.tryParse(p[0]) ?? 0;
  final m = int.tryParse(p[1]) ?? 0;
  return (h.clamp(0, 23) * 60) + m.clamp(0, 59);
}

String formatHm(int hour, int minute) {
  final h = hour.clamp(0, 23).toString().padLeft(2, '0');
  final m = minute.clamp(0, 59).toString().padLeft(2, '0');
  return '$h:$m';
}

/// Quiet hours. A window that spans midnight (22:00–07:00) is supported.
/// End is exclusive. Equal start and end means the window is empty.
bool inQuietHours({
  required String start,
  required String end,
  required DateTime now,
}) {
  final startMin = minutesFromHm(start);
  final endMin = minutesFromHm(end);
  final t = now.hour * 60 + now.minute;
  if (startMin == endMin) return false;
  if (startMin < endMin) {
    return t >= startMin && t < endMin;
  }
  return t >= startMin || t < endMin;
}

Set<String> firedKeysForDate(String raw, String date) {
  if (date.isEmpty || !raw.startsWith('$date:')) return {};
  final rest = raw.substring(date.length + 1);
  if (rest.isEmpty) return {};
  return rest.split(',').where((s) => s.isNotEmpty).toSet();
}

String encodeFired(String date, Set<String> keys) {
  return '$date:${keys.join(',')}';
}
