import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(PulsePathApp());
}

class PulsePathApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulsePath',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
