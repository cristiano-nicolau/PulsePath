import 'package:flutter/material.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final double calories;
  final double steps;
  final double distance;
  final double speed;

  const WorkoutDetailsPage({
    Key? key,
    required this.calories,
    required this.steps,
    required this.distance,
    required this.speed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout Details")),
      body: ListView(
        children: [
          ListTile(title: Text('Calories: ${calories.toStringAsFixed(2)}')),
          ListTile(title: Text('Steps: $steps')),
          ListTile(title: Text('Distance: ${distance.toStringAsFixed(2)} km')),
          ListTile(title: Text('Speed: ${speed.toStringAsFixed(2)} km/h')),
        ],
      ),
    );
  }
}
