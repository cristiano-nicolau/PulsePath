class SensorData {
  final int? id;
  final int userId;
  final String heartRate;
  final String calories;
  final String steps;
  final String distance;
  final String speed;
  final String water;
  DateTime receivedDate;

  SensorData(
      {this.id,
      required this.userId,
      required this.heartRate,
      required this.calories,
      required this.steps,
      required this.distance,
      required this.speed,
      required this.water,
      required this.receivedDate});

  factory SensorData.fromMap(Map<String, dynamic> json) => SensorData(
        id: json['id'] as int?,
        userId: json['userId'] as int,
        heartRate: json['heartRate'] as String,
        calories: json['calories'] as String,
        steps: json['steps'] as String,
        distance: json['distance'] as String,
        speed: json['speed'] as String,
        water: json['water'] as String,
        receivedDate: DateTime.parse(json['receivedDate']),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'heartRate': heartRate,
      'calories': calories,
      'steps': steps,
      'distance': distance,
      'speed': speed,
      'water': water,
      'receivedDate': receivedDate.toIso8601String(),
    };
  }
}
