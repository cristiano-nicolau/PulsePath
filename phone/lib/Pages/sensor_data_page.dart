import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone/components/card.dart';
import '../services/database_helper.dart';
import '../../models/sensor_data_model.dart';

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  late Future<List<SensorData>> _sensorData;
  final storage = FlutterSecureStorage();
  String name = '';
  String lastUpdate = '';
  Flag

  @override
  void initState() {
    super.initState();
    _sensorData = DatabaseHelper.instance.fetchSensorData();
    storage.write(key: 'lastUpdate', value: DateTime.now().toString());
    _getNameFromStorage();
  }

  String _calculateTimeDifference(String storedTime) {
  // Parse the stored time string to DateTime object
  DateTime storedDateTime = DateTime.parse(storedTime);

  // Calculate the difference between the stored time and the current time
  Duration difference = DateTime.now().difference(storedDateTime);

  // Convert the difference into days, hours, or minutes
  if (difference.inDays > 0) {
    print('${difference.inDays} days ago');
    return '${difference.inDays} days ago';
  } else if (difference.inHours > 0) {
        print('${difference.inDays} days ago');

    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes > 0) {
        print('${difference.inDays} days ago');

    return '${difference.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}

  Future<void> _getNameFromStorage() async {
    name = (await storage.read(key: 'name'))!;
    String storedLastUpdate = (await storage.read(key: 'lastUpdate'))!;
    lastUpdate = _calculateTimeDifference(storedLastUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
        
        Column(
      children: [

        const SizedBox(height: 75),
        Container(
          padding:
              EdgeInsets.only(left: 35), // Adicione a margem à esquerda aqui
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hello,',
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        Container(
          padding:
              EdgeInsets.only(left: 35), // Adicione a margem à esquerda aqui
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.yellow.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    width: 35, // Largura do ícone
                    height: 35, // Altura do ícone
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Arredondamento das bordas
                      color: const Color(0xFFFBDC8E), // Cor do ícone
                    ),
                    child: Icon(
                      Icons.info,
                      color: Colors.white, // Cor do ícone
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'You have not checked out the app recently. \nDo some work to get back on track!',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),

            child: Container(
              child: Row(
                children: [
                  
                  Text(
                    'Last updated: $lastUpdate',
                    style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 73, 73, 73)),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      // reload the page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SensorDataPage()),
                      );
                     
                    },
                    child: Icon(Icons.refresh_rounded , color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      
                      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
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
              title: 'Temperature',
              icon: Icons.thermostat,
              color: Colors.blue,
              subtitle: '25',
              unit: '°C',
            ),
            CustomCard(
              title: 'Temperature',
              icon: Icons.thermostat,
              color: Colors.blue,
              subtitle: '25',
              unit: '°C',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              title: 'Temperature',
              icon: Icons.thermostat,
              color: Colors.blue,
              subtitle: '25',
              unit: '°C',
            ),
            CustomCard(
              title: 'Temperature',
              icon: Icons.thermostat,
              color: Colors.blue,
              subtitle: '25',
              unit: '°C',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              title: 'Temperature',
              icon: Icons.thermostat,
              color: Colors.blue,
              subtitle: '25',
              unit: '°C',
            ),
            CustomCard(
              title: 'Temperature',
              icon: Icons.thermostat,
              color: Colors.blue,
              subtitle: '25',
              unit: '°C',
            ),
          ],
        ),
      ],
    ));
  }
}
