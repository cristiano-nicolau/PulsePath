// main.dart

import 'package:flutter/material.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to activity tracking screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActivityTrackingScreen()),
                );
              },
              child: Text('Track Activity'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to stats screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatsScreen()),
                );
              },
              child: Text('View Stats'),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Activity'),
      ),
      body: Center(
        child: Text('Activity tracking screen'),
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Stats'),
      ),
      body: Center(
        child: Text('Stats screen'),
      ),
    );
  }
}
