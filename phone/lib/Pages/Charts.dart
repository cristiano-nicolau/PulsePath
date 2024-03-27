import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../models/heart_rate_model.dart';
import '../models/sensor_data_model.dart';
import '../services/database_helper.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key}) : super(key: key);

  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> with TickerProviderStateMixin {
  late TabController _topTabController;
  late TabController _bottomTabController;
  late List<SensorData> _chartData;
  late List<SensorData> _weeklyChartData;
  late List<SensorData> _monthlyChartData;
  late List<SensorData> _dailyBPMData;
  late List<HeartRateExtremes> _weeklyBPMData;
  late List<HeartRateExtremes> _monthlyBPMData;

  @override
  void initState() {
    super.initState();
    _topTabController = TabController(length: 3, vsync: this);
    _bottomTabController = TabController(length: 3, vsync: this);
    _chartData = [];
    _weeklyChartData = [];
    _monthlyChartData = [];
    _dailyBPMData = [];
    _weeklyBPMData = [];
    _monthlyBPMData = [];
    _fetchDailyBPMData();
    _fetchWeeklyBPMData();
    _fetchMonthlyBPMData();
    _fetchDailySensorData();
    _fetchWeeklySensorData();
    _fetchMonthlySensorData();
  }

  void _fetchDailySensorData() async {
    _chartData = await DatabaseHelper.instance.fetchDailySensorData();
    setState(() {});
  }

  void _fetchWeeklySensorData() async {
    _weeklyChartData = await DatabaseHelper.instance.fetchWeeklySensorData();
    setState(() {});
  }

  void _fetchMonthlySensorData() async {
    _monthlyChartData = await DatabaseHelper.instance.fetchMonthlySensorData();
    setState(() {});
  }

  void _fetchDailyBPMData() async {
    _dailyBPMData = await DatabaseHelper.instance.fetchTodaysHeartRateData();
    setState(() {});
  }

  void _fetchWeeklyBPMData() async {
    _weeklyBPMData = await DatabaseHelper.instance.fetchWeeklyHeartRateData();
    setState(() {});
  }

  void _fetchMonthlyBPMData() async {
    _monthlyBPMData = await DatabaseHelper.instance.fetchMonthlyHeartRateData();
    setState(() {});
  }

  @override
  void dispose() {
    _topTabController.dispose();
    _bottomTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _bottomTabController,
          tabs: const [
            Tab(text: "Workout"),
            Tab(text: "Water"),
            Tab(text: "BPM"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _bottomTabController,
        children: [
          _buildCategoryTab("Workout"),
          _buildCategoryTab("Water"),
          _buildCategoryTab("BPM"),
        ],
      ),
    );
  }

  Widget _buildDailyChart(String category) {
    switch (category) {
      case "Workout":
        return _buildDailyWorkoutChart();
      case "Water":
        return _buildDailyWaterChart();
      case "BPM":
        return _buildDailyBPMChart();
      default:
        return Container();
    }
  }

  Widget _buildWeeklyChart(String category) {
    switch (category) {
      case "Workout":
        return _buildWeeklyWorkoutChart();
      case "Water":
        return _buildWeeklyWaterChart();
      case "BPM":
        return _buildWeeklyBPMChart();
      default:
        return Container();
    }
  }

  Widget _buildMonthlyChart(String category) {
    switch (category) {
      case "Workout":
        return _buildMonthlyWorkoutChart();
      case "Water":
        return _buildMonthlyWaterChart();
      case "BPM":
        return _buildMonthlyBPMChart();
      default:
        return Container();
    }
  }

  Widget _buildCategoryTab(String category) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: TabBar(
            controller: _topTabController,
            tabs: const [
              Tab(text: "Daily"),
              Tab(text: "Weekly"),
              Tab(text: "Monthly"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _topTabController,
            children: [
              _buildDailyChart(category),
              _buildWeeklyChart(category),
              _buildMonthlyChart(category),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyWorkoutChart() {
    final defaultData = [
      SensorData(
        userId: 0,
        heartRate: "0",
        calories: "0",
        steps: "0",
        distance: "0",
        speed: "0",
        water: "0",
        receivedDate: DateTime.now(),
      ),
    ];

    // Use _chartData if it's not empty; otherwise, use defaultData
    final chartDataSource = _chartData.isNotEmpty ? _chartData : defaultData;

    return SfCircularChart(
      title: const ChartTitle(text: 'Daily Workout Summary'),
      legend: const Legend(
          isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries>[
        RadialBarSeries<SensorData, String>(
          dataSource: chartDataSource,
          xValueMapper: (SensorData data, _) => 'Steps',
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.steps) ?? 0,
          name: 'Steps',
          radius: '100%',
          pointColorMapper: (SensorData data, _) => Colors.green,
          maximumValue: 10000, // Adjust maximum value as needed
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        RadialBarSeries<SensorData, String>(
          dataSource: chartDataSource,
          xValueMapper: (SensorData data, _) => 'Calories',
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.calories) ?? 0,
          name: 'Calories',
          radius: '70%',
          pointColorMapper: (SensorData data, _) => Colors.orange,
          maximumValue: 500, // Adjust maximum value as needed
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        RadialBarSeries<SensorData, String>(
          dataSource: chartDataSource,
          xValueMapper: (SensorData data, _) => 'Distance',
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.distance) ?? 0,
          name: 'Distance',
          radius: '40%',
          pointColorMapper: (SensorData data, _) => Colors.blue,
          maximumValue: 8, // Adjust maximum value as needed
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildWeeklyWorkoutChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      series: <CartesianSeries>[
        ColumnSeries<SensorData, String>(
          dataSource: _weeklyChartData,
          xValueMapper: (SensorData data, _) =>
              DateFormat('dd/MM').format(data.receivedDate),
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.steps) ?? 0,
          name: 'Steps',
          color: Colors.green,
        ),
        ColumnSeries<SensorData, String>(
          dataSource: _weeklyChartData,
          xValueMapper: (SensorData data, _) =>
              DateFormat('dd/MM').format(data.receivedDate),
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.calories) ?? 0,
          name: 'Calories',
          color: Colors.red,
        ),
        ColumnSeries<SensorData, String>(
          dataSource: _weeklyChartData,
          xValueMapper: (SensorData data, _) =>
              DateFormat('dd/MM').format(data.receivedDate),
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.distance) ?? 0,
          name: 'Distance',
          color: Colors.blue,
        ),
      ],
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  Widget _buildMonthlyWorkoutChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      series: <CartesianSeries>[
        ColumnSeries<SensorData, String>(
          dataSource: _monthlyChartData,
          xValueMapper: (SensorData data, _) =>
              DateFormat('dd/MM').format(data.receivedDate),
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.steps) ?? 0,
          name: 'Steps',
          color: Colors.green,
        ),
        ColumnSeries<SensorData, String>(
          dataSource: _monthlyChartData,
          xValueMapper: (SensorData data, _) =>
              DateFormat('dd/MM').format(data.receivedDate),
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.calories) ?? 0,
          name: 'Calories',
          color: Colors.red,
        ),
        ColumnSeries<SensorData, String>(
          dataSource: _monthlyChartData,
          xValueMapper: (SensorData data, _) =>
              DateFormat('dd/MM').format(data.receivedDate),
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.distance) ?? 0,
          name: 'Distance',
          color: Colors.blue,
        ),
      ],
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  Widget _buildDailyWaterChart() {
    final defaultData = [
      SensorData(
        userId: 0,
        heartRate: "0",
        calories: "0",
        steps: "0",
        distance: "0",
        speed: "0",
        water: "0",
        receivedDate: DateTime.now(),
      ),
    ];

    // Use _chartData if it's not empty; otherwise, use defaultData
    final chartDataSource = _chartData.isNotEmpty ? _chartData : defaultData;

    return SfCircularChart(
      title: const ChartTitle(text: 'Daily Water Intake'),
      legend: const Legend(
          isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries>[
        RadialBarSeries<SensorData, String>(
          dataSource: chartDataSource,
          xValueMapper: (SensorData data, _) => 'Water',
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.water) ?? 0,
          name: 'Water Intake',
          radius: '100%',
          pointColorMapper: (SensorData data, _) => Colors.blue,
          maximumValue: 8,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildWeeklyWaterChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      series: <CartesianSeries>[
        ColumnSeries<SensorData, String>(
          dataSource: _weeklyChartData,
          xValueMapper: (SensorData data, _) =>
              DateFormat('dd/MM').format(data.receivedDate),
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.water) ?? 0,
          name: 'Water',
          color: Colors.blue,
        ),
      ],
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  Widget _buildMonthlyWaterChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      series: <CartesianSeries>[
        ColumnSeries<SensorData, String>(
          dataSource: _monthlyChartData,
          xValueMapper: (SensorData data, _) =>
              DateFormat('dd/MM').format(data.receivedDate),
          yValueMapper: (SensorData data, _) =>
              double.tryParse(data.water) ?? 0,
          name: 'Water',
          color: Colors.blue,
        ),
      ],
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  Widget _buildDailyBPMChart() {
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            intervalType:
                DateTimeIntervalType.hours, // To adjust interval type as needed
            dateFormat:
                DateFormat.Hm(), // Format X-axis labels as hour and minute
            majorGridLines: const MajorGridLines(width: 0),
            title: const AxisTitle(text: 'Hours'),
          ),
          primaryYAxis: const NumericAxis(
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0),
            title: AxisTitle(text: 'Heart Rate (BPM)'),
          ),
          series: <CartesianSeries>[
            LineSeries<SensorData, DateTime>(
              dataSource: _dailyBPMData,
              xValueMapper: (SensorData data, _) => data.receivedDate,
              yValueMapper: (SensorData data, _) =>
                  int.tryParse(data.heartRate),
              name: 'Heart Rate',
              markerSettings:
                  const MarkerSettings(isVisible: true), // Show markers
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true), // Enable tooltips
        ),
      ),
    );
  }

  Widget _buildWeeklyBPMChart() {
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Weekly Heart Rate Extremes'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Day'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Heart Rate (BPM)'),
          ),
          series: <RangeColumnSeries<HeartRateExtremes, String>>[
            RangeColumnSeries<HeartRateExtremes, String>(
              dataSource: _weeklyBPMData,
              xValueMapper: (HeartRateExtremes extremes, _) =>
                  DateFormat('E').format(extremes.date), // Short day format
              lowValueMapper: (HeartRateExtremes extremes, _) =>
                  extremes.minHeartRate,
              highValueMapper: (HeartRateExtremes extremes, _) =>
                  extremes.maxHeartRate,
              name: 'Heart Rate',
              dataLabelSettings:
                  const DataLabelSettings(isVisible: true), // Show data labels
              color: Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            )
          ],
          tooltipBehavior: TooltipBehavior(enable: true), // Enable tooltips
        ),
      ),
    );
  }

  Widget _buildMonthlyBPMChart() {
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Monthly Heart Rate Extremes'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Day'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Heart Rate (BPM)'),
          ),
          series: <RangeColumnSeries<HeartRateExtremes, String>>[
            RangeColumnSeries<HeartRateExtremes, String>(
              dataSource:
                  _monthlyBPMData, // Your list of HeartRateExtremes data
              xValueMapper: (HeartRateExtremes extremes, _) =>
                  DateFormat('d').format(extremes.date), // Day of the month
              lowValueMapper: (HeartRateExtremes extremes, _) =>
                  extremes.minHeartRate,
              highValueMapper: (HeartRateExtremes extremes, _) =>
                  extremes.maxHeartRate,
              name: 'Heart Rate',
              dataLabelSettings:
                  const DataLabelSettings(isVisible: true), // Show data labels
              color: Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            )
          ],
          tooltipBehavior: TooltipBehavior(enable: true), // Enable tooltips
        ),
      ),
    );
  }
}
