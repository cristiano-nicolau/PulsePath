import 'dart:math';

import 'package:flutter/material.dart';
import 'package:workout/workout.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:weather/weather.dart';
import 'WorkoutDetailsPage.dart';

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
        textTheme: const TextTheme(
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
  int waterIntake = 0;
  late WeatherFactory wf;
  Weather? currentWeather;

  @override
  void initState() {
    super.initState();
    initializeMqttClient();
    startWorkoutListener();
    wf = WeatherFactory("d6df89e388607f46bc0a46185094466b",
        language: Language.PORTUGUESE);
    fetchWeather();
  }

  // Fetch weather data
  Future<void> fetchWeather() async {
    try {
      Weather w = await wf.currentWeatherByCityName("Aveiro, PT");
      setState(() {
        currentWeather = w;
      });
    } catch (e) {
      print("Failed to fetch weather data: $e");
    }
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
    workout
        .start(
      exerciseType: ExerciseType.walking,
      features: [
        WorkoutFeature.heartRate,
        WorkoutFeature.calories,
        WorkoutFeature.steps,
        WorkoutFeature.distance,
        WorkoutFeature.speed,
      ],
      enableGps: true,
    )
        .then((result) {
      if (result.unsupportedFeatures.isNotEmpty) {
        print('Unsupported features: ${result.unsupportedFeatures}');
      } else {
        print(
            'Workout started successfully with all requested features supported');
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
        'Heart Rate: $heartRate, Calories: $calories, Steps: $steps, Distance: $distance, Speed: $speed, Water Intake: $waterIntake';

    final builder = MqttClientPayloadBuilder();
    builder.addString(sensorData);

    client.publishMessage('sensor/data', MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen size
    final screenSize = MediaQuery.of(context).size;
    final pageHeight = screenSize.height;
    final pageWidth = screenSize.width;

    // Calculate the size of the content to ensure it's visible in a round display
    // This is a basic approach; you might need to adjust it based on your actual content
    final contentSize = min(pageWidth, pageHeight);

    return Scaffold(
      body: PageView(
        controller: PageController(
            viewportFraction: 1.0), // Ensure each page takes full screen
        scrollDirection: Axis.vertical,
        children: [
          Center(
              child: _statTile('Heart Rate', '$heartRate bpm', Icons.favorite,
                  Colors.red, contentSize)),
          Center(
              child: _statTile(
                  'Weather',
                  currentWeather != null
                      ? "${currentWeather!.weatherDescription}, ${currentWeather!.temperature!.celsius!.toStringAsFixed(1)}°C"
                      : "Loading...",
                  Icons.wb_sunny,
                  Colors.orange,
                  contentSize)),
          Center(child: _waterIntakeTile(contentSize * 0.95)),
          Center(child: _workoutNavigatorTile(context, contentSize)),
        ],
      ),
    );
  }

  Widget _workoutNavigatorTile(BuildContext context, double size) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkoutDetailsPage(
                  calories: calories,
                  steps: steps,
                  distance: distance,
                  speed: speed))),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fitness_center, size: size * 0.3, color: Colors.green),
              SizedBox(height: size * 0.05),
              Text(
                'Workout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: size * 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statTile(
      String title, String value, IconData icon, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: size * 0.3, color: color),
            SizedBox(height: size * 0.05),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: size * 0.1,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: size * 0.08,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waterIntakeTile(double size) {
    double progressValue = waterIntake / 8.0; // Assuming 8 is the target value

    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progressValue, // Current progress
              strokeWidth: 10, // Width of the progress indicator
              backgroundColor:
                  Colors.grey, // Background color of the progress bar
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue), // Color of the progress bar
            ),
          ),
          // Water Intake Content
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_drink, size: size * 0.3, color: Colors.blue),
                  SizedBox(height: size * 0.05),
                  Text(
                    'Water',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: size * 0.1,
                    ),
                  ),
                  Text(
                    '$waterIntake',
                    style: TextStyle(
                      fontSize: size * 0.08,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            if (waterIntake > 0) {
                              waterIntake--;
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            waterIntake++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
