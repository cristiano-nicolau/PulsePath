class HeartRateExtremes {
  final DateTime date;
  final int minHeartRate;
  final int maxHeartRate;

  HeartRateExtremes({
    required this.date,
    required this.minHeartRate,
    required this.maxHeartRate,
  });

  factory HeartRateExtremes.fromMap(Map<String, dynamic> map) {
    return HeartRateExtremes(
      date: DateTime.parse(map['date']),
      minHeartRate: int.parse(map['minHeartRate']),
      maxHeartRate: int.parse(map['maxHeartRate']),
    );
  }

  @override
  String toString() {
    return 'Date: $date, Min Heart Rate: $minHeartRate, Max Heart Rate: $maxHeartRate';
  }
}
