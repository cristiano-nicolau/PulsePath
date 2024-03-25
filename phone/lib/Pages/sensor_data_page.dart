import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone/Pages/Login.dart';
import '../services/database_helper.dart';
import '../../models/sensor_data_model.dart';

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  late Future<List<SensorData>> _sensorData;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _sensorData = DatabaseHelper.instance.fetchSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor Data"),
        actions: [
          IconButton(
            onPressed: () async {
              await storage.delete(key: 'token');
              // Navegue de volta para a tela de login 
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<SensorData>>(
        future: _sensorData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('An error occurred!'));
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  SensorData data = snapshot.data![index];
                  return ListTile(
                    title: Text("Heart Rate: ${data.heartRate}, Steps: ${data.steps}"),
                    subtitle: Text("Calories: ${data.calories}, Distance: ${data.distance}, Speed: ${data.speed}"),
                  );
                },
              );
            } else {
              return Center(child: Text('No data available'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
