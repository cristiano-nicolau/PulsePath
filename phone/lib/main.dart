import 'package:flutter/material.dart';
import 'package:phone/Pages/Login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Pages/sensor_data_page.dart';
import '../Pages/Login.dart';
import '/services/mqtt_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mqttService = MqttService();
  await mqttService.initializeMqttClient();
  final storage = FlutterSecureStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
          textTheme: TextTheme(
            subtitle1: TextStyle(color: Colors.black), //<-- SEE HERE
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      home: FutureBuilder<String?>(
        future: storage.read(key: 'token'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              print("encontrado token");
              return SensorDataPage();
            } else {
              print("no encontrado token");
              return LoginPage();
            }
          }
        },
      ),);
  }
}
