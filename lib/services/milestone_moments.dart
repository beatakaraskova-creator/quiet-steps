import 'milestones.dart';
import 'step_math.dart';
import 'store.dart';

/// A fired milestone that the pop-up can show.
class MilestoneMoment {
  const MilestoneMoment({
    required this.date,
    required this.key,
    required this.line,
    required this.language,
    required this.live,
  });

  final String date;
  final String key;
  final String line;
  final String language;

  /// Fired while the app screen was open: the app plays the tune and the voice.
  /// False for a catch-up on the next open: the tune only, because the
  /// background task already spoke it (or quiet hours kept it silent).
  final bool live;

  String get id => '$date|$key';
}

/// A live milestone older than this is treated as a catch-up (no voice).
const liveMomentWindow = Duration(minutes: 10);

/// The latest milestone of today's step-day that has not been shown yet.
/// Only one is ever returned; older days are dropped.
MilestoneMoment? pendingMilestoneMoment(
  Store store, {
  required String language,
  DateTime? now,
}) {
  final t = now ?? DateTime.now();
  final today = store.todayDate.isNotEmpty ? store.todayDate : todayKey(t);
  final date = store.latestMilestoneDate;
  final key = store.latestMilestoneKey;
  if (date.isEmpty || key.isEmpty || date != today) return null;
  final id = '$date|$key';
  if (store.milestoneSeen == id) return null;

  var line = store.latestMilestoneLine.trim();
  if (store.latestMilestoneLang != language) {
    final again = pickMilestoneLine(
      language: language,
      style: store.milestoneStyle,
      milestone: key,
      day: DateTime.tryParse(date),
    );
    if (again.isNotEmpty) line = again;
  }
  if (line.isEmpty) return null;

  final at = store.latestMilestoneAtMs;
  final age = t.millisecondsSinceEpoch - at;
  final live = store.latestMilestoneLive &&
      at > 0 &&
      age >= -60000 &&
      age <= liveMomentWindow.inMilliseconds;
  return MilestoneMoment(
    date: date,
    key: key,
    line: line,
    language: language,
    live: live,
  );
}

/// Mark a moment as shown. Called when the pop-up opens, so it never repeats.
void markMilestoneSeen(Store store, MilestoneMoment moment) {
  store.milestoneSeen = moment.id;
}
