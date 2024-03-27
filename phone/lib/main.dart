import 'package:flutter/material.dart';
import '../Pages/Home.dart';
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
      debugShowCheckedModeBanner: false,
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return HomePage();
          });
        },
      ),
    );
  }
}
