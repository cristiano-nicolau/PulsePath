import 'package:flutter/material.dart';
import '../sensor_data_page.dart';
import '/services/mqtt_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mqttService = MqttService();
  await mqttService.initializeMqttClient();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Sensor Data App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SensorDataPage(),
    );
  }
}
