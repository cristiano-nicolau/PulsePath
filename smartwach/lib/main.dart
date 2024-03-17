import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StepCounterScreen(),
    );
  }
}

class StepCounterScreen extends StatefulWidget {
  @override
  _StepCounterScreenState createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  HealthFactory _health = HealthFactory(); // Class-level instance

  List<HealthDataPoint> _stepData = [];

  @override
  void initState() {
    super.initState();
    _fetchStepData();
  }

  Future<void> _fetchStepData() async {
    try {
      await _health.requestAuthorization();
      List<HealthDataType> types = [HealthDataType.STEP_COUNT];
      DateTime now = DateTime.now();
      DateTime start = DateTime(now.year, now.month, now.day, 0, 0, 0);
      List<HealthDataPoint> healthData =
          await _health.getHealthDataFromTypes(start, now, types);
      setState(() {
        _stepData = healthData;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> requestPermission() async {
  final HealthFactory health = HealthFactory();
  bool granted = await health.requestAuthorization();
  print('Authorization: $granted');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
      ),
      body: _stepData.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _stepData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Steps: ${_stepData[index].value}'),
                  subtitle: Text('Date: ${_stepData[index].dateTo}'), // Corrected date property
                );
              },
            ),
    );
  }
}
