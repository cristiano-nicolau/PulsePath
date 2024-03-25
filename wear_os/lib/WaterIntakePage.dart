import 'package:flutter/material.dart';

class WaterIntakePage extends StatefulWidget {
  final int initialWaterIntake;
  final Function(int) onWaterIntakeUpdated;

  const WaterIntakePage({
    Key? key,
    required this.initialWaterIntake,
    required this.onWaterIntakeUpdated,
  }) : super(key: key);

  @override
  _WaterIntakePageState createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  late int currentWaterIntake;

  @override
  void initState() {
    super.initState();
    currentWaterIntake = widget.initialWaterIntake;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Water Intake", style: TextStyle(fontSize: 18)), // Reduced font size
        centerTitle: true,
        toolbarHeight: 20, // Reduced height
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_drink, size: 20, color: Colors.blueAccent), // Reduced size
            SizedBox(height: 10),
            Text(
              '$currentWaterIntake Glasses',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), // Reduced font size
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  mini: true, // Make FABs smaller
                  onPressed: () {
                    setState(() {
                      if (currentWaterIntake > 0) currentWaterIntake--;
                    });
                  },
                  child: Icon(Icons.remove, size: 20), // Reduced icon size
                  backgroundColor: Colors.red,
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  mini: true, // Make FABs smaller
                  onPressed: () {
                    setState(() {
                      currentWaterIntake++;
                    });
                  },
                  child: Icon(Icons.add, size: 20), // Reduced icon size
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced padding
                textStyle: TextStyle(fontSize: 16), // Reduced text size
              ),
              onPressed: () {
                widget.onWaterIntakeUpdated(currentWaterIntake);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
