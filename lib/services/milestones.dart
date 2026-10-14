import 'dart:math';

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

/// Pick one line from `milestoneLines[language][style][milestone]`.
/// Unknown language falls back to English.
String pickMilestoneLine({
  required String language,
  required String style,
  required String milestone,
  int Function(int max)? nextInt,
}) {
  final langKey = milestoneLines.containsKey(language) ? language : 'en';
  final langMap = milestoneLines[langKey] ?? milestoneLines['en']!;
  final styleKey = langMap.containsKey(style) ? style : 'calm';
  var lines = langMap[styleKey]?[milestone];
  if (lines == null || lines.isEmpty) {
    lines = milestoneLines['en']?[styleKey]?[milestone] ??
        milestoneLines['en']?['calm']?[milestone];
  }
  if (lines == null || lines.isEmpty) return '';
  final pick = nextInt ?? Random().nextInt;
  final i = pick(lines.length).clamp(0, lines.length - 1);
  return lines[i];
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
