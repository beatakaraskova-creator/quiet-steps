import 'store.dart';

String todayKey([DateTime? now]) {
  final d = now ?? DateTime.now();
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
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
    await store.lockDay(store.todayDate, store.todaySteps);
    store.todayDate = key;
    store.todayOffset = raw;
    store.todaySteps = 0;
    store.lastRaw = raw;
    return 0;
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
