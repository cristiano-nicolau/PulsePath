import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Wear OS Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            if (mode == WearMode.ambient) {
              return AmbientWatchFace();
            } else {
              return ActiveWatchFace();
            }
          },
        );
      },
    );
  }
}

class AmbientWatchFace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Ambient Mode',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ActiveWatchFace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Active Mode')),
      body: Center(child: Text('Hello, Wear OS!')),
    );
  }
}
