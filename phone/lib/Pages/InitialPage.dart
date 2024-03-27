import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone/Pages/MainPage.dart';
import 'package:phone/components/GenderCard.dart';
import 'package:phone/models/userinfo.dart';
import 'package:phone/services/database_helper.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String selectedGender = 'male';
  double age = 20;
  double weight = 50;
  double height = 150;
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            const Text(
              'Give us some basic information',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = 'male';
                    });
                  },
                  child: GenderCard(
                    gender: 'Male',
                    icon: Icons.man,
                    isSelected: selectedGender == 'male',
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = 'female';
                    });
                  },
                  child: GenderCard(
                    gender: 'Female',
                    icon: Icons.woman,
                    isSelected: selectedGender == 'female',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              'Age',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: age,
              onChanged: (value) {
                setState(() {
                  age = value;
                });
              },
              min: 0,
              max: 100,
              divisions: 100,
              label: age.round().toString(),
            ),
            const SizedBox(height: 50),
            const Text(
              'Weight',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: weight,
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
              min: 0,
              max: 150,
              divisions: 150,
              label: weight.round().toString(),
            ),
            const SizedBox(height: 50),
            const Text(
              'Height',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: height,
              onChanged: (value) {
                setState(() {
                  height = value;
                });
              },
              min: 0,
              max: 250,
              divisions: 250,
              label: height.round().toString(),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00335E),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  textStyle: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  // vai buscar o id do user ao storage
                  // e guarda a informação do user
                  await storage.read(key: 'id').then((value) {
                    final data = UserInfo(
                      userId: int.parse(value!),
                      gender: selectedGender,
                      age: age.round().toString(),
                      weight: weight.round().toString(),
                      height: height.round().toString(),
                    );

                    DatabaseHelper.instance.insertUsersInfo(data).then((value) {
                      print('User info inserida com sucesso');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                      );
                    });
                  });
                },
                child: const Icon(Icons.arrow_forward, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
