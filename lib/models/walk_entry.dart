class WalkEntry {
  WalkEntry({
    required this.id,
    required this.mood,
    required this.steps,
    required this.minutes,
    required this.note,
    required this.startedAt,
    required this.endedAt,
  });

  final String id;
  final String mood;
  final int steps;
  final int minutes;
  final String note;
  final String startedAt;
  final String endedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mood': mood,
        'steps': steps,
        'minutes': minutes,
        'note': note,
        'startedAt': startedAt,
        'endedAt': endedAt,
      };

  factory WalkEntry.fromJson(Map<String, dynamic> json) {
    return WalkEntry(
      id: json['id'] as String? ?? '',
      mood: json['mood'] as String? ?? 'move',
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      minutes: (json['minutes'] as num?)?.toInt() ?? 0,
      note: json['note'] as String? ?? '',
      startedAt: json['startedAt'] as String? ?? '',
      endedAt: json['endedAt'] as String? ?? '',
    );
  }
}
