import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Pages/Home.dart';
import '/services/mqtt_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mqttService = MqttService();
  await mqttService.initializeMqttClient();
  final storage = FlutterSecureStorage();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigator( // Adiciona um Navigator como raiz da aplicação
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return HomePage(); // Sua página inicial aqui
          });
        },
      ),
    );
  }
}