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
    // Phone rebooted. Keep today's count and start from the new raw value.
    store.todayOffset = raw - store.todaySteps;
    if (store.todayOffset < 0) store.todayOffset = 0;
  }

  var steps = raw - store.todayOffset;
  if (steps < 0) steps = 0;
  store.todaySteps = steps;
  store.lastRaw = raw;
  return steps;
}
