import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:projectone/database/DBHelper.dart';
import 'package:projectone/database/apiutils.dart';
import 'package:projectone/home/home_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int prestasiCount = 0;
  int prokerCount = 0;
  int kegiatanCount = 0;
  bool isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    int? userId = await DBHelper.getUserId();
    setState(() {
      _userId = userId;
      if (_userId != null) {
        _fetchCounts(_userId!);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchCounts(int userId) async {
    final url =
        Uri.parse(ApiUtils.buildUrl('api/dashboard/counts?user_id=$userId'));

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          prestasiCount = data['prestasi_count'];
          prokerCount = data['proker_count'];
          kegiatanCount = data['kegiatan_count'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load counts');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    if (_userId != null) {
      await _fetchCounts(_userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildCard(
                      icon: Icons.emoji_events,
                      color: Colors.green,
                      title: 'Prestasi',
                      subtitle: 'Jumlah Prestasi $prestasiCount',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(initialIndex: 1)),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    _buildCard(
                      icon: Icons.book_rounded,
                      color: Colors.orange,
                      title: 'Program Kerja',
                      subtitle: 'Jumlah Program Kerja $prokerCount',
                      onTap: () {
                        if (_userId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(initialIndex: 2)),
                          );
                        } else {
                          print("User ID is not initialized");
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    _buildCard(
                      icon: Icons.calendar_month_rounded,
                      color: Colors.cyan,
                      title: 'Kegiatan',
                      subtitle:
                          'Jumlah Kegiatan $kegiatanCount',
                      onTap: () {
                        if (_userId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(initialIndex: 3)),
                          );
                        } else {
                          print("User ID is not initialized");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required void Function() onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.6), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: color, size: 30),
            radius: 30,
          ),
          title: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle,
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          onTap: onTap,
        ),
      ),
    );
  }
}
