import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiet_steps/services/step_math.dart';
import 'package:quiet_steps/services/store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Store store;

  Future<void> fresh([Map<String, Object> seed = const {}]) async {
    SharedPreferences.setMockInitialValues(Map<String, Object>.from(seed));
    store = Store.instance;
    await store.init();
  }

  test('todayKey is yyyy-MM-dd', () {
    final d = DateTime(2026, 9, 16);
    expect(todayKey(d), '2026-09-16');
  });

  test('normal counting subtracts the offset', () async {
    await fresh();
    expect(await applyRawSteps(store, 1000), 0);
    expect(await applyRawSteps(store, 1040), 40);
    expect(await applyRawSteps(store, 1100), 100);
    expect(store.todaySteps, 100);
    expect(store.lastRaw, 1100);
  });

  test('reboot keeps today when raw counter drops', () async {
    await fresh();
    await applyRawSteps(store, 8000);
    await applyRawSteps(store, 8500);
    expect(store.todaySteps, 500);

    // Sensor restarts after reboot.
    expect(await applyRawSteps(store, 12), 500);
    expect(store.todayOffset, 12 - 500);
    expect(await applyRawSteps(store, 40), 528);
    expect(store.todaySteps, 528);
  });

  test('midnight rollover locks yesterday and starts a new day', () async {
    await fresh();
    await applyRawSteps(store, 100);
    await applyRawSteps(store, 400);
    expect(store.todaySteps, 300);

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    store.todayDate = todayKey(yesterday);

    expect(await applyRawSteps(store, 410), 0);
    expect(store.todaySteps, 0);
    expect(store.todayOffset, 410);
    final hist = store.history();
    expect(hist.length, 1);
    expect(hist.first.date, todayKey(yesterday));
    expect(hist.first.steps, 300);
  });

  test('pause skips steps taken while stopped', () async {
    await fresh();
    await applyRawSteps(store, 1000);
    await applyRawSteps(store, 1100);
    expect(store.todaySteps, 100);

    store.skipPausedGap = true;
    expect(await applyRawSteps(store, 1600), 100);
    expect(store.skipPausedGap, isFalse);
    expect(await applyRawSteps(store, 1610), 110);
  });

  test('rollover without a new step event zeroes today', () async {
    await fresh();
    await applyRawSteps(store, 1000);
    await applyRawSteps(store, 1640);
    expect(store.todaySteps, 640);
    final yesterday = todayKey(DateTime.now().subtract(const Duration(days: 1)));
    store.todayDate = yesterday;
    store.firedMilestonesRaw = '$yesterday:2500,goal';
    store.latestMilestoneLine = 'Goal reached. Be proud of this.';
    store.latestMilestoneDate = yesterday;

    expect(await rollOverIfNewDay(store), isTrue);
    expect(store.todayDate, todayKey());
    expect(store.todaySteps, 0);
    expect(store.todayOffset, 1640);
    expect(store.lastRaw, 1640);
    expect(store.firedMilestonesRaw, isEmpty);
    expect(store.todaysMilestoneLine(), isEmpty);
    final hist = store.history();
    expect(hist.first.date, yesterday);
    expect(hist.first.steps, 640);

    expect(await rollOverIfNewDay(store), isFalse);
    expect(await applyRawSteps(store, 1640), 0);
    expect(await applyRawSteps(store, 1655), 15);
  });

  test('reset makes the next raw reading the new zero', () async {
    await fresh();
    await applyRawSteps(store, 2000);
    await applyRawSteps(store, 2500);
    expect(store.todaySteps, 500);

    resetTodayCount(store);
    expect(store.todaySteps, 0);
    expect(store.todayOffset, 2500);

    expect(await applyRawSteps(store, 2500), 0);
    expect(await applyRawSteps(store, 2510), 10);
  });
}
