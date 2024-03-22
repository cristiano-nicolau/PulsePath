class SensorData {
  final int? id;
  final String heartRate;
  final String calories;
  final String steps;
  final String distance;
  final String speed;

  SensorData({this.id, required this.heartRate, required this.calories, required this.steps, required this.distance, required this.speed});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'heartRate': heartRate,
      'calories': calories,
      'steps': steps,
      'distance': distance,
      'speed': speed,
    };
  }
}
