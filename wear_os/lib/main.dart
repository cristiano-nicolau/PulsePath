import 'package:flutter/material.dart';
import 'package:workout/workout.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'WaterIntakePage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardTheme(
          color: Colors.grey[800],
          shadowColor: Colors.black,
          elevation: 5,
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: const SensorStatsPage(),
    );
  }
}

class SensorStatsPage extends StatefulWidget {
  const SensorStatsPage({Key? key}) : super(key: key);

  @override
  _SensorStatsPageState createState() => _SensorStatsPageState();
}

class _SensorStatsPageState extends State<SensorStatsPage> {
  final workout = Workout();
  late MqttServerClient client;

  double heartRate = 0;
  double calories = 0;
  double steps = 0;
  double distance = 0;
  double speed = 0;
  int waterIntake = 0; // Added for water intake tracking

  @override
  void initState() {
    super.initState();
    initializeMqttClient();
    startWorkoutListener();
    // Start automatically
  }

  Future<void> initializeMqttClient() async {
    client = MqttServerClient('broker.emqx.io', 'flutter_client_wear');
    client.logging(on: true);

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
  }

  void startWorkoutListener() {
    workout.start(
      exerciseType: ExerciseType.walking,
      features: [
        WorkoutFeature.heartRate,
        WorkoutFeature.calories,
        WorkoutFeature.steps,
        WorkoutFeature.distance,
        WorkoutFeature.speed,
      ],
      enableGps: true,
    ).then((result) {
      if (result.unsupportedFeatures.isNotEmpty) {
        print('Unsupported features: ${result.unsupportedFeatures}');
      } else {
        print('Workout started successfully with all requested features supported');
        workout.stream.listen((event) {
          print('Received workout update: $event');
          setState(() {
            switch (event.feature) {
              case WorkoutFeature.heartRate:
                heartRate = event.value;
                break;
              case WorkoutFeature.calories:
                calories = event.value;
                break;
              case WorkoutFeature.steps:
                steps = event.value;
                break;
              case WorkoutFeature.distance:
                distance = event.value;
                break;
              case WorkoutFeature.speed:
                speed = event.value;
                break;
              default:
                break;
            }
          });
        });
      }
    }).catchError((error) {
      print('Error starting workout: $error');
    });
  }


  void publishSensorData() {
    final sensorData =
        'Heart Rate: $heartRate, Calories: $calories, Steps: $steps, Distance: $distance, Speed: $speed';
    final builder = MqttClientPayloadBuilder();
    builder.addString(sensorData);

    client.publishMessage('sensor/data', MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _statTile('Heart Rate', '$heartRate bpm', Icons.favorite, Colors.red),
          _statTile('Calories', '${calories.toStringAsFixed(2)} kcal', Icons.local_fire_department, Colors.orange),
          _statTile('Steps', '$steps steps', Icons.directions_walk, Colors.blue),
          _waterIntakeTile(),
          _statTile('Distance', '${distance.toStringAsFixed(2)} m', Icons.map, Colors.purple),
          _statTile('Speed', '${speed.toStringAsFixed(2)} m/s', Icons.speed, Colors.green),
        ],
      ),
    );
  }

  Widget _statTile(String title, String value, IconData icon, Color color) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            Text(value, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _waterIntakeTile() {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WaterIntakePage(initialWaterIntake: waterIntake, onWaterIntakeUpdated: (int updatedValue) {
      setState(() {
        waterIntake = updatedValue;
      });
    }))),
    child: Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_drink, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text('Water', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            Text('$waterIntake', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    ),
  );
}

}