import 'dart:convert';

import '../l10n/backup_text.dart';
import '../models/day_record.dart';
import '../models/walk_entry.dart';
import 'milestones.dart';
import 'step_math.dart';
import 'store.dart';
import 'streaks.dart';
import 'walks.dart';

const backupFormatVersion = 1;
const quietStepsAppVersion = '1.0.0';
const maxDaySteps = 1000000;
const maxBackupDays = 400;

final _dateRe = RegExp(r'^\d{4}-\d{2}-\d{2}$');
final _timeRe = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

enum BackupError { invalid, tooNew }

class BackupSettings {
  const BackupSettings({
    required this.goal,
    required this.heightCm,
    required this.strideCm,
    required this.weightKg,
    required this.lookId,
    required this.fontScale,
    required this.lookCustom,
    required this.lookAccent,
    required this.lookBgColor,
    required this.milestoneMessages,
    required this.speakMessages,
    required this.voiceSpeed,
    required this.milestoneStyle,
    required this.quietHours,
    required this.quietStart,
    required this.quietEnd,
    required this.language,
    required this.onboardingDone,
    required this.firedMilestonesRaw,
  });

  final int goal;
  final int heightCm;
  final int strideCm;
  final int weightKg;
  final String lookId;
  final double fontScale;
  final bool lookCustom;
  final int lookAccent;
  final int lookBgColor;
  final bool milestoneMessages;
  final bool speakMessages;
  final String voiceSpeed;
  final String milestoneStyle;
  final bool quietHours;
  final String quietStart;
  final String quietEnd;
  final String language;
  final bool onboardingDone;
  final String firedMilestonesRaw;

  Map<String, dynamic> toJson() => {
        'goal': goal,
        'heightCm': heightCm,
        'strideCm': strideCm,
        'weightKg': weightKg,
        'lookId': lookId,
        'fontScale': fontScale,
        'lookCustom': lookCustom,
        'lookAccent': lookAccent,
        'lookBgColor': lookBgColor,
        'milestoneMessages': milestoneMessages,
        'speakMessages': speakMessages,
        'voiceSpeed': voiceSpeed,
        'milestoneStyle': milestoneStyle,
        'quietHours': quietHours,
        'quietStart': quietStart,
        'quietEnd': quietEnd,
        'language': language,
        'onboardingDone': onboardingDone,
        'firedMilestones': firedMilestonesRaw,
      };

  static BackupSettings defaults() => const BackupSettings(
        goal: 8000,
        heightCm: 170,
        strideCm: 73,
        weightKg: 75,
        lookId: 'quiet_gold',
        fontScale: 1.0,
        lookCustom: false,
        lookAccent: 0xFFC4A574,
        lookBgColor: 0xFF141412,
        milestoneMessages: true,
        speakMessages: false,
        voiceSpeed: 'normal',
        milestoneStyle: 'calm',
        quietHours: true,
        quietStart: '22:00',
        quietEnd: '07:00',
        language: 'auto',
        onboardingDone: true,
        firedMilestonesRaw: '',
      );
}

class BackupSnapshot {
  const BackupSnapshot({
    required this.formatVersion,
    required this.appVersion,
    required this.exportedAt,
    required this.history,
    required this.goodDays,
    required this.restDates,
    required this.reflectionEnabled,
    required this.reflectionTime,
    required this.lastReflectionDate,
    required this.walks,
    required this.settings,
  });

  final int formatVersion;
  final String appVersion;
  final String exportedAt;
  final List<DayRecord> history;
  final int goodDays;
  final List<String> restDates;
  final bool reflectionEnabled;
  final String reflectionTime;
  final String lastReflectionDate;
  final List<WalkEntry> walks;
  final BackupSettings settings;

  Map<String, dynamic> toJson() => {
        'formatVersion': formatVersion,
        'appVersion': appVersion,
        'exportedAt': exportedAt,
        'history': history.map((e) => e.toJson()).toList(),
        'streak': {
          'goodDays': goodDays,
          'restDates': restDates,
        },
        'reflection': {
          'enabled': reflectionEnabled,
          'time': reflectionTime,
          'lastDate': lastReflectionDate,
        },
        'walks': walks.map((e) => e.toJson()).toList(),
        'settings': settings.toJson(),
      };
}

class BackupParseResult {
  const BackupParseResult.ok(this.snapshot) : error = null;
  const BackupParseResult.fail(this.error) : snapshot = null;

  final BackupSnapshot? snapshot;
  final BackupError? error;

  bool get isOk => snapshot != null;
}

String backupUiLine(String language, String key) {
  final lang = backupUi.containsKey(language) ? language : 'en';
  return backupUi[lang]?[key] ?? backupUi['en']?[key] ?? key;
}

String backupConfirmBody(String language, {required int days, required int walks}) {
  return backupUiLine(language, 'confirmBody')
      .replaceAll('{days}', '$days')
      .replaceAll('{walks}', '$walks');
}

String backupFileName(DateTime now) =>
    'quiet-steps-backup-${todayKey(now)}.json';

String encodeBackup(BackupSnapshot snapshot) {
  return const JsonEncoder.withIndent('  ').convert(snapshot.toJson());
}

List<DayRecord> historyIncludingToday(Store store) {
  final days = store.history();
  if (store.todayDate.isEmpty) return days;
  final next = [
    DayRecord(date: store.todayDate, steps: store.todaySteps),
    ...days.where((d) => d.date != store.todayDate),
  ];
  next.sort((a, b) => b.date.compareTo(a.date));
  return next;
}

BackupSnapshot snapshotFromStore(
  Store store, {
  DateTime? now,
  String appVersion = quietStepsAppVersion,
}) {
  final at = now ?? DateTime.now();
  final history = historyIncludingToday(store);
  final stepsByDate = {for (final d in history) d.date: d.steps};
  final streak = computeStreak(
    stepsByDate: stepsByDate,
    goal: store.goal,
    now: at,
  );
  final rest = streak.restDates.toList()..sort();
  return BackupSnapshot(
    formatVersion: backupFormatVersion,
    appVersion: appVersion,
    exportedAt: at.toIso8601String(),
    history: history,
    goodDays: streak.goodDays,
    restDates: rest,
    reflectionEnabled: store.eveningReflection,
    reflectionTime: store.reflectionTime,
    lastReflectionDate: store.lastReflectionDate,
    walks: store.walks(),
    settings: BackupSettings(
      goal: store.goal,
      heightCm: store.heightCm,
      strideCm: store.strideCm,
      weightKg: store.weightKg,
      lookId: store.lookId,
      fontScale: store.fontScale,
      lookCustom: store.lookCustom,
      lookAccent: store.lookAccent,
      lookBgColor: store.lookBgColor,
      milestoneMessages: store.milestoneMessages,
      speakMessages: store.speakMessages,
      voiceSpeed: store.voiceSpeed,
      milestoneStyle: store.milestoneStyle,
      quietHours: store.quietHours,
      quietStart: store.quietStart,
      quietEnd: store.quietEnd,
      language: store.language,
      onboardingDone: store.onboardingDone,
      firedMilestonesRaw: store.firedMilestonesRaw,
    ),
  );
}

BackupParseResult parseBackup(String raw) {
  Object? decoded;
  try {
    decoded = jsonDecode(raw);
  } catch (_) {
    return const BackupParseResult.fail(BackupError.invalid);
  }
  if (decoded is! Map) {
    return const BackupParseResult.fail(BackupError.invalid);
  }
  final map = Map<String, dynamic>.from(decoded);

  final versionRaw = map['formatVersion'] ?? map['format_version'] ?? map['version'];
  var version = 0;
  if (versionRaw != null) {
    if (versionRaw is num) {
      version = versionRaw.toInt();
    } else {
      version = int.tryParse('$versionRaw') ?? -1;
    }
  }
  if (version > backupFormatVersion) {
    return const BackupParseResult.fail(BackupError.tooNew);
  }
  if (version < 0) {
    return const BackupParseResult.fail(BackupError.invalid);
  }

  final historyRaw = map['history'] ?? map['days'];
  if (historyRaw != null && historyRaw is! List) {
    return const BackupParseResult.fail(BackupError.invalid);
  }
  final history = <DayRecord>[];
  if (historyRaw is List) {
    if (historyRaw.length > maxBackupDays) {
      return const BackupParseResult.fail(BackupError.invalid);
    }
    for (final item in historyRaw) {
      final day = _parseDay(item);
      if (day == null) {
        return const BackupParseResult.fail(BackupError.invalid);
      }
      history.add(day);
    }
  }
  history.sort((a, b) => b.date.compareTo(a.date));

  final walksRaw = map['walks'];
  if (walksRaw != null && walksRaw is! List) {
    return const BackupParseResult.fail(BackupError.invalid);
  }
  final walks = <WalkEntry>[];
  if (walksRaw is List) {
    if (walksRaw.length > maxWalkJournal + 50) {
      return const BackupParseResult.fail(BackupError.invalid);
    }
    for (final item in walksRaw) {
      final walk = _parseWalk(item);
      if (walk == null) {
        return const BackupParseResult.fail(BackupError.invalid);
      }
      walks.add(walk);
    }
  }

  final settingsRaw = map['settings'];
  if (settingsRaw != null && settingsRaw is! Map) {
    return const BackupParseResult.fail(BackupError.invalid);
  }
  final settings = _parseSettings(
    settingsRaw is Map ? Map<String, dynamic>.from(settingsRaw) : const {},
  );
  if (settings == null) {
    return const BackupParseResult.fail(BackupError.invalid);
  }

  final reflectionRaw = map['reflection'];
  final reflection = reflectionRaw is Map
      ? Map<String, dynamic>.from(reflectionRaw)
      : <String, dynamic>{};

  final reflectionEnabled = reflection['enabled'] is bool
      ? reflection['enabled'] as bool
      : (map['eveningReflection'] is bool
          ? map['eveningReflection'] as bool
          : true);

  final reflectionTime = _asTime(reflection['time']) ??
      _asTime(map['reflectionTime']) ??
      reflectionFallback;
  if (!_timeRe.hasMatch(reflectionTime)) {
    return const BackupParseResult.fail(BackupError.invalid);
  }

  final lastDate = (reflection['lastDate'] ?? map['lastReflectionDate'] ?? '')
      .toString();
  if (lastDate.isNotEmpty && !_dateRe.hasMatch(lastDate)) {
    return const BackupParseResult.fail(BackupError.invalid);
  }

  final streakRaw = map['streak'];
  final streak = streakRaw is Map
      ? Map<String, dynamic>.from(streakRaw)
      : <String, dynamic>{};
  final goodDays = (streak['goodDays'] as num?)?.toInt() ?? 0;
  if (goodDays < 0 || goodDays > 400) {
    return const BackupParseResult.fail(BackupError.invalid);
  }
  final rest = <String>[];
  final restRaw = streak['restDates'];
  if (restRaw != null) {
    if (restRaw is! List) {
      return const BackupParseResult.fail(BackupError.invalid);
    }
    for (final item in restRaw) {
      final s = item.toString();
      if (!_dateRe.hasMatch(s)) {
        return const BackupParseResult.fail(BackupError.invalid);
      }
      rest.add(s);
    }
  }

  final exportedAt = (map['exportedAt'] ?? map['exportDate'] ?? '').toString();
  final appVersion = (map['appVersion'] ?? quietStepsAppVersion).toString();

  return BackupParseResult.ok(
    BackupSnapshot(
      formatVersion: version == 0 ? backupFormatVersion : version,
      appVersion: appVersion,
      exportedAt: exportedAt,
      history: history,
      goodDays: goodDays,
      restDates: rest,
      reflectionEnabled: reflectionEnabled,
      reflectionTime: reflectionTime,
      lastReflectionDate: lastDate,
      walks: walks,
      settings: settings,
    ),
  );
}

const reflectionFallback = '20:30';

DayRecord? _parseDay(dynamic raw) {
  if (raw is! Map) return null;
  final date = raw['date']?.toString() ?? '';
  if (!_dateRe.hasMatch(date)) return null;
  final steps = (raw['steps'] as num?)?.toInt();
  if (steps == null || steps < 0 || steps > maxDaySteps) return null;
  return DayRecord(date: date, steps: steps);
}

WalkEntry? _parseWalk(dynamic raw) {
  if (raw is! Map) return null;
  final id = raw['id']?.toString() ?? '';
  if (id.isEmpty) return null;
  final steps = (raw['steps'] as num?)?.toInt() ?? 0;
  final minutes = (raw['minutes'] as num?)?.toInt() ?? 0;
  if (steps < 0 || steps > maxDaySteps) return null;
  if (minutes < 0 || minutes > 24 * 60) return null;
  final mood = raw['mood']?.toString() ?? 'move';
  final note = clipWalkNote(raw['note']?.toString() ?? '');
  final startedAt = raw['startedAt']?.toString() ?? '';
  final endedAt = raw['endedAt']?.toString() ?? '';
  return WalkEntry(
    id: id,
    mood: mood,
    steps: steps,
    minutes: minutes,
    note: note,
    startedAt: startedAt,
    endedAt: endedAt,
  );
}

String? _asTime(dynamic raw) {
  if (raw == null) return null;
  final s = raw.toString();
  return _timeRe.hasMatch(s) ? s : null;
}

int? _boundedInt(dynamic raw, {required int min, required int max}) {
  final v = (raw as num?)?.toInt();
  if (v == null || v < min || v > max) return null;
  return v;
}

BackupSettings? _parseSettings(Map<String, dynamic> raw) {
  final d = BackupSettings.defaults();
  int pickInt(String k, int fallback, {required int min, required int max}) {
    if (!raw.containsKey(k)) return fallback;
    return _boundedInt(raw[k], min: min, max: max) ?? -1;
  }

  final goal = pickInt('goal', d.goal, min: 100, max: 1000000);
  if (goal < 0) return null;
  final heightCm = pickInt('heightCm', d.heightCm, min: 50, max: 250);
  if (heightCm < 0) return null;
  final strideCm = pickInt('strideCm', d.strideCm, min: 20, max: 200);
  if (strideCm < 0) return null;
  final weightKg = pickInt('weightKg', d.weightKg, min: 20, max: 400);
  if (weightKg < 0) return null;

  var fontScale = d.fontScale;
  if (raw.containsKey('fontScale')) {
    final v = (raw['fontScale'] as num?)?.toDouble();
    if (v == null || v < 0.5 || v > 2.0) return null;
    fontScale = v.clamp(0.85, 1.35);
  }

  final lookAccent = pickInt('lookAccent', d.lookAccent, min: 0, max: 0xFFFFFFFF);
  if (lookAccent < 0) return null;
  final lookBgColor =
      pickInt('lookBgColor', d.lookBgColor, min: 0, max: 0xFFFFFFFF);
  if (lookBgColor < 0) return null;

  final voice = (raw['voiceSpeed'] ?? d.voiceSpeed).toString();
  if (voice != 'slow' && voice != 'normal') return null;
  final style = (raw['milestoneStyle'] ?? d.milestoneStyle).toString();
  if (style != 'calm' && style != 'cheerful') return null;
  final language = (raw['language'] ?? d.language).toString();
  if (language != 'auto' && !supportedLanguages.contains(language)) {
    return null;
  }
  final quietStart = _asTime(raw['quietStart']) ?? d.quietStart;
  final quietEnd = _asTime(raw['quietEnd']) ?? d.quietEnd;
  if (!_timeRe.hasMatch(quietStart) || !_timeRe.hasMatch(quietEnd)) {
    return null;
  }

  bool b(String k, bool fallback) {
    final v = raw[k];
    if (v is bool) return v;
    return fallback;
  }

  final lookId = (raw['lookId'] ?? d.lookId).toString();
  final fired = (raw['firedMilestones'] ?? d.firedMilestonesRaw).toString();

  return BackupSettings(
    goal: goal,
    heightCm: heightCm,
    strideCm: strideCm,
    weightKg: weightKg,
    lookId: lookId,
    fontScale: fontScale,
    lookCustom: b('lookCustom', d.lookCustom),
    lookAccent: lookAccent,
    lookBgColor: lookBgColor,
    milestoneMessages: b('milestoneMessages', d.milestoneMessages),
    speakMessages: b('speakMessages', d.speakMessages),
    voiceSpeed: voice,
    milestoneStyle: style,
    quietHours: b('quietHours', d.quietHours),
    quietStart: quietStart,
    quietEnd: quietEnd,
    language: language,
    onboardingDone: b('onboardingDone', d.onboardingDone),
    firedMilestonesRaw: fired,
  );
}

List<DayRecord> mergeHistory(List<DayRecord> local, List<DayRecord> incoming) {
  final map = <String, int>{for (final d in local) d.date: d.steps};
  for (final d in incoming) {
    final cur = map[d.date];
    if (cur == null || d.steps > cur) map[d.date] = d.steps;
  }
  return [
    for (final e in map.entries) DayRecord(date: e.key, steps: e.value),
  ]..sort((a, b) => b.date.compareTo(a.date));
}

List<WalkEntry> mergeWalks(List<WalkEntry> local, List<WalkEntry> incoming) {
  final byId = <String, WalkEntry>{};
  for (final w in incoming) {
    if (w.id.isEmpty) continue;
    byId[w.id] = w;
  }
  for (final w in local) {
    if (w.id.isEmpty) continue;
    byId[w.id] = w;
  }
  final list = byId.values.toList()
    ..sort((a, b) => b.endedAt.compareTo(a.endedAt));
  if (list.length <= maxWalkJournal) return list;
  return list.take(maxWalkJournal).toList();
}

String mergeFired(String local, String incoming) {
  if (incoming.isEmpty) return local;
  if (local.isEmpty) return incoming;
  final localDate = local.split(':').first;
  final inDate = incoming.split(':').first;
  if (localDate != inDate) return local;
  final keys = {
    ...firedKeysForDate(local, localDate),
    ...firedKeysForDate(incoming, inDate),
  };
  return encodeFired(localDate, keys);
}

Future<void> applyBackupToStore(
  Store store,
  BackupSnapshot data, {
  required bool replace,
  DateTime? now,
}) async {
  final localHistory = historyIncludingToday(store);
  final history = replace
      ? [...data.history]
      : mergeHistory(localHistory, data.history);
  final walks = replace
      ? [...data.walks]
      : mergeWalks(store.walks(), data.walks);

  final today = store.todayDate.isEmpty
      ? todayKey(now)
      : store.todayDate;
  DayRecord? todayRec;
  final past = <DayRecord>[];
  for (final d in history) {
    if (d.date == today) {
      todayRec = d;
    } else {
      past.add(d);
    }
  }
  await store.saveHistory(past);
  if (store.todayDate.isEmpty) store.todayDate = today;
  if (todayRec != null) {
    store.todaySteps = todayRec.steps;
    store.todayOffset = store.lastRaw - todayRec.steps;
  }

  final cappedWalks = walks.length > maxWalkJournal
      ? walks.take(maxWalkJournal).toList()
      : walks;
  await store.saveWalks(cappedWalks);

  if (replace) {
    _writeSettings(store, data.settings);
    store.eveningReflection = data.reflectionEnabled;
    store.reflectionTime = data.reflectionTime;
    store.lastReflectionDate = data.lastReflectionDate;
  } else {
    store.firedMilestonesRaw = mergeFired(
      store.firedMilestonesRaw,
      data.settings.firedMilestonesRaw,
    );
    if (data.lastReflectionDate.isNotEmpty &&
        data.lastReflectionDate.compareTo(store.lastReflectionDate) > 0) {
      store.lastReflectionDate = data.lastReflectionDate;
    }
  }
}

void _writeSettings(Store store, BackupSettings s) {
  store.goal = s.goal;
  store.heightCm = s.heightCm;
  store.strideCm = s.strideCm;
  store.weightKg = s.weightKg;
  store.lookId = s.lookId;
  store.fontScale = s.fontScale;
  store.lookCustom = s.lookCustom;
  store.lookAccent = s.lookAccent;
  store.lookBgColor = s.lookBgColor;
  store.milestoneMessages = s.milestoneMessages;
  store.speakMessages = s.speakMessages;
  store.voiceSpeed = s.voiceSpeed;
  store.milestoneStyle = s.milestoneStyle;
  store.quietHours = s.quietHours;
  store.quietStart = s.quietStart;
  store.quietEnd = s.quietEnd;
  store.language = s.language;
  store.onboardingDone = s.onboardingDone;
  store.firedMilestonesRaw = s.firedMilestonesRaw;
}

bool backupJsonLooksPrivate(String json) {
  final lower = json.toLowerCase();
  for (final key in [
    'androidid',
    'android_id',
    'deviceid',
    'device_id',
    'advertisingid',
    'lastraw',
    'last_raw',
    'todayoffset',
    'today_offset',
    'backgroundpath',
    'bg_path',
  ]) {
    if (lower.contains('"$key"')) return false;
  }
  return true;
}
