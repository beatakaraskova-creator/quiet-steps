class DayRecord {
  DayRecord({required this.date, required this.steps});

  final String date; // yyyy-MM-dd
  final int steps;

  Map<String, dynamic> toJson() => {'date': date, 'steps': steps};

  factory DayRecord.fromJson(Map<String, dynamic> json) {
    return DayRecord(
      date: json['date'] as String,
      steps: (json['steps'] as num).toInt(),
    );
  }
}
