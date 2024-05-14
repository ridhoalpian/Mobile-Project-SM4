import 'package:flutter/material.dart';

class DashboarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Icon(Icons.analytics, color: Colors.blue),
              title: Text('Analytics'),
              subtitle: Text('View detailed analytics'),
              onTap: () {
                // Handle tap
              },
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Icon(Icons.assignment, color: Colors.green),
              title: Text('Tasks'),
              subtitle: Text('View and manage tasks'),
              onTap: () {
                // Handle tap
              },
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Icon(Icons.event, color: Colors.red),
              title: Text('Events'),
              subtitle: Text('View upcoming events'),
              onTap: () {
                // Handle tap
              },
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.orange),
              title: Text('Notifications'),
              subtitle: Text('View recent notifications'),
              onTap: () {
                // Handle tap
              },
            ),
          ),
        ],
      ),
    );
  }
}
