import 'store.dart';
import 'walks.dart';

String todayKey([DateTime? now]) {
  final d = now ?? DateTime.now();
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}

void _carryWalkPastMidnight(Store store, int yesterdaySteps) {
  if (!store.walkActive) return;
  store.walkCarrySteps = walkCarryAfterMidnight(
    walkActive: true,
    startSteps: store.walkStartSteps,
    yesterdaySteps: yesterdaySteps,
    currentCarry: store.walkCarrySteps,
  );
  store.walkStartSteps = 0;
}

/// Roll the stored day to [todayKey] with no new sensor reading.
/// Locks yesterday, zeroes today, keeps [Store.lastRaw] as the baseline
/// so the next event counts from 0, and clears today's milestone card.
/// Returns true when a rollover happened.
Future<bool> rollOverIfNewDay(Store store) async {
  final key = todayKey();
  if (store.todayDate.isEmpty || store.todayDate == key) return false;
  final yesterdaySteps = store.todaySteps;
  await store.lockDay(store.todayDate, yesterdaySteps);
  _carryWalkPastMidnight(store, yesterdaySteps);
  store.todayDate = key;
  store.todayOffset = store.lastRaw;
  store.todaySteps = 0;
  store.firedMilestonesRaw = '';
  store.clearLatestMilestone();
  return true;
}

/// Apply a raw hardware step-counter reading (steps since last boot).
/// Returns today's steps after the update.
Future<int> applyRawSteps(Store store, int raw) async {
  final key = todayKey();

  if (store.todayDate.isEmpty) {
    store.todayDate = key;
    store.todayOffset = raw;
    store.todaySteps = 0;
    store.lastRaw = raw;
    return 0;
  }

  if (store.todayDate != key) {
    final yesterdaySteps = store.todaySteps;
    await store.lockDay(store.todayDate, yesterdaySteps);
    _carryWalkPastMidnight(store, yesterdaySteps);
    store.todayDate = key;
    store.todayOffset = raw;
    store.todaySteps = 0;
    store.lastRaw = raw;
    store.firedMilestonesRaw = '';
    store.clearLatestMilestone();
    return 0;
  }

  if (store.skipPausedGap) {
    // Pause: drop steps taken while stopped. Keep today's total.
    store.todayOffset = raw - store.todaySteps;
    store.lastRaw = raw;
    store.skipPausedGap = false;
    return store.todaySteps;
  }

  if (raw < store.lastRaw) {
    // Phone rebooted. Raw counter restarted. Keep today's count with a
    // negative offset so the next reading still adds on.
    store.todayOffset = raw - store.todaySteps;
  }

  var steps = raw - store.todayOffset;
  if (steps < 0) steps = 0;
  store.todaySteps = steps;
  store.lastRaw = raw;
  return steps;
}

/// Next raw reading becomes the new zero for today.
void resetTodayCount(Store store) {
  store.todayOffset = store.lastRaw;
  store.todaySteps = 0;
}
