import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'MainPage.dart';
import 'Login.dart';

class HomePage extends StatelessWidget {
  final storage = const FlutterSecureStorage();

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
            const SizedBox(height: 30),
            const Text(
              'Welcome to \nyour personal \nhealth assistant',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                String? token = await storage.read(key: 'token');
                String? name = await storage.read(key: 'name');
                if (token != null) {
                  print("Token encontrado");
                  print(name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                } else {
                  print("Token não encontrado");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
