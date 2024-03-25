import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'sensor_data_page.dart';
import 'Login.dart';
import '../services/mqtt_service.dart';


class HomePage extends StatelessWidget {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/welcome.jpg',
              width: 250,
              height: 450,
            ),
            SizedBox(height: 30),
            Text(
              'Welcome to \nyour personal \nhealth assistant',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                String? token = await storage.read(key: 'token');
                if (token != null) {
                  print("Token encontrado");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SensorDataPage()),
                  );
                } else {
                  print("Token não encontrado");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              child: Icon(Icons.arrow_forward, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}