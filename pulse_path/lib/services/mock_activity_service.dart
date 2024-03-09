import '../models/activity.dart';

class MockActivityService {
  static final List<Activity> _activities = [
    Activity('Running', 1, 5, 7000, 120),
    Activity('Walking', 0.5, 2, 3000, 80),
    Activity('Cycling', 2, 20, 0, 110),
  ];

  static Future<List<Activity>> getActivities() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    return _activities;
  }
}
