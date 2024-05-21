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
              leading: Icon(Icons.emoji_events, color: Colors.green),
              title: Text('Prestasi'),
              subtitle: Text('Jumlah Prestasi 0'),
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
              leading: Icon(Icons.book_rounded, color: Colors.orange),
              title: Text('Program Kerja'),
              subtitle: Text('Jumlah Program Kerja 0'),
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
              leading: Icon(Icons.calendar_month_rounded, color: Colors.cyan),
              title: Text('Kegiatan'),
              subtitle: Text('Jumlah Kegiatan 0'),
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
