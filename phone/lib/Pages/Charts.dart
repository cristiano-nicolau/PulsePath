import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';


class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key}) : super(key: key);

  
  @override
  _ChartsPageState createState() => _ChartsPageState();
}
class _ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Material(
                  child: TabBar(
                    indicatorColor: Colors.green,
                    tabs: [
                      Tab(
                        text: "Dayly",
                      ),
                      Tab(
                        text: "Weekly",
                      ),
                      Tab(
                        text: "Monthly",
                      ),
                    ],
                    labelColor: Colors.black,
                    indicator: MaterialIndicator(
                      height: 5,
                      topLeftRadius: 8,
                      topRightRadius: 8,
                      horizontalPadding: 5,
                      tabPosition: TabPosition.bottom,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                // Alterações aqui
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 60, // Altura fixa para a TabBar de baixo
                      child: Material(
                        child: TabBar(
                          indicatorColor: Colors.green,
                          tabs: [
                            Tab(
                              text: "Workout",
                            ),
                            Tab(
                              text: "Water",
                            ),
                            Tab(
                              text: "BPM",
                            ),
                          ],
                          labelColor: Colors.black,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelColor: Colors.grey,
                          indicator: DotIndicator(
                            color: const Color.fromARGB(255, 255, 0, 0),
                            distanceFromCenter: 16,
                            radius: 4,
                            paintingStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
