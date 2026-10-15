import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_steps/l10n/backup_text.dart';
import 'package:quiet_steps/models/day_record.dart';
import 'package:quiet_steps/models/walk_entry.dart';
import 'package:quiet_steps/services/backup.dart';
import 'package:quiet_steps/services/milestones.dart';
import 'package:quiet_steps/services/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

WalkEntry _walk(String id, {int steps = 100, String note = ''}) {
  return WalkEntry(
    id: id,
    mood: 'move',
    steps: steps,
    minutes: 10,
    note: note,
    startedAt: '2026-10-14T10:00:00.000',
    endedAt: '2026-10-14T10:10:00.000',
  );
}

BackupSnapshot _sample({
  List<DayRecord>? history,
  List<WalkEntry>? walks,
  BackupSettings? settings,
}) {
  return BackupSnapshot(
    formatVersion: backupFormatVersion,
    appVersion: quietStepsAppVersion,
    exportedAt: '2026-10-14T12:00:00.000',
    history: history ??
        [
          DayRecord(date: '2026-10-14', steps: 3200),
          DayRecord(date: '2026-10-13', steps: 8100),
        ],
    goodDays: 1,
    restDates: const ['2026-10-12'],
    reflectionEnabled: true,
    reflectionTime: '20:30',
    lastReflectionDate: '2026-10-13',
    walks: walks ?? [_walk('w1', note: 'lane')],
    settings: settings ?? BackupSettings.defaults(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('export then import round-trip', () {
    test('JSON round-trip keeps history, walks and settings', () {
      final original = _sample(
        settings: BackupSettings.defaults().letGoal(9000),
      );
      final json = encodeBackup(original);
      expect(backupJsonLooksPrivate(json), isTrue);
      final parsed = parseBackup(json);
      expect(parsed.isOk, isTrue);
      final got = parsed.snapshot!;
      expect(got.formatVersion, backupFormatVersion);
      expect(got.history.map((d) => '${d.date}:${d.steps}'), [
        '2026-10-14:3200',
        '2026-10-13:8100',
      ]);
      expect(got.walks.single.id, 'w1');
      expect(got.walks.single.note, 'lane');
      expect(got.settings.goal, 9000);
      expect(got.reflectionTime, '20:30');
      expect(got.lastReflectionDate, '2026-10-13');
      expect(got.restDates, ['2026-10-12']);
    });

    test('store export then replace import matches', () async {
      SharedPreferences.setMockInitialValues({});
      final store = Store.instance;
      await store.init();
      store.goal = 7500;
      store.language = 'sk';
      store.todayDate = '2026-10-14';
      store.todaySteps = 1200;
      store.lastRaw = 50000;
      await store.saveHistory([DayRecord(date: '2026-10-13', steps: 8000)]);
      await store.addWalk(_walk('a', note: 'park'));
      store.eveningReflection = true;
      store.reflectionTime = '21:00';
      store.lastReflectionDate = '2026-10-13';

      final now = DateTime(2026, 10, 14, 18);
      final json = encodeBackup(snapshotFromStore(store, now: now));
      expect(json.contains('lastRaw'), isFalse);
      expect(json.contains('todayOffset'), isFalse);
      expect(json.contains('device'), isFalse);

      SharedPreferences.setMockInitialValues({});
      await store.init();
      expect(store.history(), isEmpty);
      expect(store.goal, 8000);

      final parsed = parseBackup(json);
      expect(parsed.isOk, isTrue);
      await applyBackupToStore(
        store,
        parsed.snapshot!,
        replace: true,
        now: now,
      );

      expect(store.goal, 7500);
      expect(store.language, 'sk');
      expect(store.todayDate, '2026-10-14');
      expect(store.todaySteps, 1200);
      expect(store.history().single.steps, 8000);
      expect(store.walks().single.note, 'park');
      expect(store.reflectionTime, '21:00');
      expect(store.lastReflectionDate, '2026-10-13');
    });
  });

  group('merge rules', () {
    test('keeps the higher step count per day and adds missing days', () {
      final local = [
        DayRecord(date: '2026-10-02', steps: 5000),
        DayRecord(date: '2026-10-01', steps: 1000),
      ];
      final incoming = [
        DayRecord(date: '2026-10-03', steps: 50),
        DayRecord(date: '2026-10-02', steps: 4000),
        DayRecord(date: '2026-10-01', steps: 2000),
      ];
      final merged = mergeHistory(local, incoming);
      expect(
        merged.map((d) => '${d.date}:${d.steps}'),
        ['2026-10-03:50', '2026-10-02:5000', '2026-10-01:2000'],
      );
    });

    test('adds missing walks and keeps the local entry on the same id', () {
      final local = [_walk('a', note: 'mine')];
      final incoming = [
        _walk('a', note: 'theirs'),
        _walk('b', note: 'new'),
      ];
      final merged = mergeWalks(local, incoming);
      expect(merged.map((w) => w.id), ['a', 'b']);
      expect(merged.first.note, 'mine');
      expect(merged.last.note, 'new');
    });

    test('store merge does not drop a higher local day', () async {
      SharedPreferences.setMockInitialValues({});
      final store = Store.instance;
      await store.init();
      store.todayDate = '2026-10-14';
      store.todaySteps = 900;
      await store.saveHistory([DayRecord(date: '2026-10-13', steps: 7000)]);
      await store.addWalk(_walk('keep'));

      final incoming = _sample(
        history: [
          DayRecord(date: '2026-10-14', steps: 400),
          DayRecord(date: '2026-10-13', steps: 8100),
          DayRecord(date: '2026-10-12', steps: 100),
        ],
        walks: [_walk('keep', note: 'ignore'), _walk('extra')],
      );
      await applyBackupToStore(
        store,
        incoming,
        replace: false,
        now: DateTime(2026, 10, 14),
      );
      expect(store.todaySteps, 900);
      expect(
        {for (final d in store.history()) d.date: d.steps},
        {'2026-10-13': 8100, '2026-10-12': 100},
      );
      expect(store.walks().map((w) => w.id).toSet(), {'keep', 'extra'});
      expect(store.walks().firstWhere((w) => w.id == 'keep').note, '');
    });
  });

  group('invalid files', () {
    test('corrupt JSON is rejected', () {
      expect(parseBackup('{').error, BackupError.invalid);
      expect(parseBackup('[]').error, BackupError.invalid);
      expect(parseBackup('not json').error, BackupError.invalid);
    });

    test('bad values are rejected', () {
      expect(
        parseBackup('{"formatVersion":1,"history":[{"date":"nope","steps":1}]}')
            .error,
        BackupError.invalid,
      );
      expect(
        parseBackup(
          '{"formatVersion":1,"history":[{"date":"2026-10-01","steps":-4}]}',
        ).error,
        BackupError.invalid,
      );
      expect(
        parseBackup(
          '{"formatVersion":1,"settings":{"goal":5}}',
        ).error,
        BackupError.invalid,
      );
    });

    test('rejected file leaves the store unchanged', () async {
      SharedPreferences.setMockInitialValues({});
      final store = Store.instance;
      await store.init();
      store.goal = 6400;
      store.todayDate = '2026-10-14';
      store.todaySteps = 222;
      await store.saveHistory([DayRecord(date: '2026-10-01', steps: 111)]);

      final parsed = parseBackup('{"formatVersion":1,"history":"nope"}');
      expect(parsed.isOk, isFalse);
      expect(store.goal, 6400);
      expect(store.todaySteps, 222);
      expect(store.history().single.steps, 111);
    });
  });

  group('older format version', () {
    test('formatVersion 0 with history is accepted', () {
      final parsed = parseBackup(
        '{"formatVersion":0,"history":[{"date":"2026-09-01","steps":500}]}',
      );
      expect(parsed.isOk, isTrue);
      expect(parsed.snapshot!.history.single.steps, 500);
      expect(parsed.snapshot!.settings.goal, 8000);
    });

    test('missing version still imports days under the old key', () {
      final parsed = parseBackup(
        '{"days":[{"date":"2026-08-02","steps":90}],"walks":[]}',
      );
      expect(parsed.isOk, isTrue);
      expect(parsed.snapshot!.history.single.date, '2026-08-02');
    });

    test('newer format version is rejected', () {
      expect(
        parseBackup('{"formatVersion":2,"history":[]}').error,
        BackupError.tooNew,
      );
    });
  });

  test('backup file name uses the export date', () {
    expect(
      backupFileName(DateTime(2026, 10, 14)),
      'quiet-steps-backup-2026-10-14.json',
    );
  });

  test('every supported language has backup copy', () {
    for (final lang in supportedLanguages) {
      for (final key in backupUi['en']!.keys) {
        expect(backupUi[lang]![key], isNotEmpty, reason: '$lang $key');
      }
    }
  });
}

extension on BackupSettings {
  BackupSettings letGoal(int goal) {
    return BackupSettings(
      goal: goal,
      heightCm: heightCm,
      strideCm: strideCm,
      weightKg: weightKg,
      lookId: lookId,
      fontScale: fontScale,
      lookCustom: lookCustom,
      lookAccent: lookAccent,
      lookBgColor: lookBgColor,
      milestoneMessages: milestoneMessages,
      speakMessages: speakMessages,
      voiceSpeed: voiceSpeed,
      milestoneStyle: milestoneStyle,
      quietHours: quietHours,
      quietStart: quietStart,
      quietEnd: quietEnd,
      language: language,
      onboardingDone: onboardingDone,
      firedMilestonesRaw: firedMilestonesRaw,
      bigSimple: bigSimple,
    );
  }
}
