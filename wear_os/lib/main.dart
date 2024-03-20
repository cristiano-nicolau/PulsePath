import 'package:flutter/material.dart';
import 'package:workout/workout.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final workout = Workout();
  late MqttServerClient client;

  final exerciseType = ExerciseType.walking;
  final features = [
    WorkoutFeature.heartRate,
    WorkoutFeature.calories,
    WorkoutFeature.steps,
    WorkoutFeature.distance,
    WorkoutFeature.speed,
  ];
  final enableGps = true;

  double heartRate = 0;
  double calories = 0;
  double steps = 0;
  double distance = 0;
  double speed = 0;
  bool started = false;

  @override
  void initState() {
    super.initState();
    initializeMqttClient();
    initializeWorkoutListener();
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

  void initializeWorkoutListener() {
    workout.stream.listen((event) {
      setState(() {
        switch (event.feature) {
          case WorkoutFeature.unknown:
            return;
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
        }
      });

      // Publica os dados atualizados via MQTT
      publishSensorData();
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
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Heart rate: $heartRate'),
              Text('Calories: ${calories.toStringAsFixed(2)}'),
              Text('Steps: $steps'),
              Text('Distance: ${distance.toStringAsFixed(2)}'),
              Text('Speed: ${speed.toStringAsFixed(2)}'),
              ElevatedButton(
                onPressed: toggleExerciseState,
                child: Text(started ? 'Stop' : 'Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleExerciseState() async {
    setState(() {
      started = !started;
    });

    if (started) {
      final supportedExerciseTypes = await workout.getSupportedExerciseTypes();
      print('Supported exercise types: ${supportedExerciseTypes.length}');

      final result = await workout.start(
        exerciseType: exerciseType,
        features: features,
        enableGps: enableGps,
      );

      if (result.unsupportedFeatures.isNotEmpty) {
        print('Unsupported features: ${result.unsupportedFeatures}');
      } else {
        print('All requested features supported');
      }
    } else {
      await workout.stop();
    }
  }
}
