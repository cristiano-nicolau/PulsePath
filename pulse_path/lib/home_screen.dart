import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/mock_activity_service.dart';

class HomeScreen extends StatelessWidget {
  Future<List<Activity>> _fetchActivities() async {
    return MockActivityService.getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PulsePath Activities'),
      ),
      body: FutureBuilder<List<Activity>>(
        future: _fetchActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching activities'));
          }

          final activities = snapshot.data!;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                title: Text(activity.name),
                subtitle: Text('Distance: ${activity.distance} km'),
                onTap: () {
                  // Navigate to activity details or start tracking
                },
              );
            },
          );
        },
      ),
    );
  }
}
