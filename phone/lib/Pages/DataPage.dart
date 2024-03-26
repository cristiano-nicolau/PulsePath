import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone/Pages/Login.dart';
import 'package:phone/Pages/MainPage.dart';
import 'package:phone/components/card.dart';
import 'package:phone/services/mqtt_service.dart';
import 'package:phone/styles/colors.dart';
import '../services/database_helper.dart';
import '../../models/sensor_data_model.dart';
import 'ProfilePage.dart';

class SensorDataPage extends StatefulWidget {
  const SensorDataPage({Key? key}) : super(key: key);

  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}


class _SensorDataPageState extends State<SensorDataPage> {
  Future<List<SensorData>> _sensorData = DatabaseHelper.instance.fetchSensorData();

  final storage = const FlutterSecureStorage();
  // Dynamic data properties
  String heartRate = "0";
  String steps = "0";
  String distance = "0";
  String calories = "0";
  String water = "0";
  String speed = "0";
  String name = '';
  String lastUpdate = '';

  @override
  void initState() {
    super.initState();
    storage.write(key: 'lastUpdate', value: DateTime.now().toString());
    _getNameFromStorage();
     MqttService().dataUpdates.listen((_) => _fetchSensorData());
  }

  void _fetchSensorData() async {
    // Fetch the latest sensor data from the database and update the state
    final sensorDataList = await DatabaseHelper.instance.fetchSensorData();
    if (sensorDataList.isNotEmpty) {
      final latestData = sensorDataList.last;
      setState(() {
        heartRate = latestData.heartRate;
        steps = latestData.steps;
        distance = latestData.distance;
        calories = latestData.calories;
        water = "Dynamically update this"; // Example, adjust accordingly
        speed = latestData.speed;
      });
    }
  }

  String _calculateTimeDifference(String storedTime) {
    // Parse the stored time string to DateTime object
    DateTime storedDateTime = DateTime.parse(storedTime);

    // Calculate the difference between the stored time and the current time
    Duration difference = DateTime.now().difference(storedDateTime);

    // Convert the difference into days, hours, or minutes
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _getNameFromStorage() async {
    String? nameStorage = await storage.read(key: 'name');
    if (nameStorage != null) {
      name = nameStorage;
    }

    String storedLastUpdate = (await storage.read(key: 'lastUpdate'))!;
    lastUpdate = _calculateTimeDifference(storedLastUpdate);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 75),
          Container(
            padding: const EdgeInsets.only(left: 35),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hello,',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 35),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.yellow.withOpacity(0.1),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFFBDC8E),
                      ),
                      child: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Expanded(
                      child: Text(
                        'You have not checked out the app recently. \nDo some work to get back on track!',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              child: Row(
                children: [
                  Text(
                    'Last updated: $lastUpdate',
                    style: const TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 73, 73, 73)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      // reload the page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    child:
                        const Icon(Icons.refresh_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCard(
                title: 'Heart Rate',
                icon: Icons.favorite,
                color: const Color(0xFFD2416E),
                subtitle: heartRate,
                unit: 'bpm',
              ),
              CustomCard(
                title: 'Steps',
                icon: Icons.directions_walk_rounded,
                color: const Color(0xFF7042C9),
                subtitle: steps,
                unit: 'steps',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCard(
                title: 'Distance',
                icon: Icons.flag,
                color: const Color(0xFF0DB1AD),
                subtitle: distance,
                unit: 'km',
              ),
              CustomCard(
                title: 'Calories',
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xFF197BD2),
                subtitle: calories,
                unit: 'kcal',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCard(
                title: 'Water',
                icon: Icons.water_damage_rounded,
                color: const Color(0xFFEDC152),
                subtitle: water,
                unit: 'glasses',
              ),
              CustomCard(
                title: 'Speed',
                icon: Icons.speed_rounded,
                color: const Color.fromARGB(255, 241, 83, 35),
                subtitle: speed,
                unit: 'km/h',
              ),
            ],
          ),
        ],
      ),
    );
  }
}



