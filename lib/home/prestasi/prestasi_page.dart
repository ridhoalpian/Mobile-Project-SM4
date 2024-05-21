import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/database/apiutils.dart';
import 'dart:convert';
import 'package:projectone/database/dbhelper.dart';
import 'package:projectone/home/prestasi/detail_prestasi.dart';
import 'package:projectone/home/prestasi/input_prestasi.dart';

class PrestasiPage extends StatefulWidget {
  @override
  _PrestasiPageState createState() => _PrestasiPageState();
}

class _PrestasiPageState extends State<PrestasiPage> {
  late Future<List<dynamic>> _futurePrestasi;
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
        _futurePrestasi = fetchPrestasi(_userId!);
      }
    });
  }

  Future<List<dynamic>> fetchPrestasi(int userId) async {
    final response = await http.get(Uri.parse(ApiUtils.buildUrl('api/prestasi?user_id=$userId')));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Membalik urutan data agar data terbaru berada di urutan pertama
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load prestasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 100,
                color: Colors.amber,
              ),
              SizedBox(height: 20),
              Text(
                'Prestasi Kami',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Berikut adalah daftar prestasi yang telah diraih:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _userId == null
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: FutureBuilder<List<dynamic>>(
                        future: _futurePrestasi,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<dynamic> prestasi = snapshot.data!;
                            return ListView.builder(
                              itemCount: prestasi.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.emoji_events,
                                      size: 30,
                                      color: Colors.amber,
                                    ),
                                    title: Text(
                                      '[${prestasi[index]['juara']}] ${prestasi[index]['namalomba']}',
                                    ),
                                    subtitle: Text(
                                      "status: '${prestasi[index]['statusprestasi']}'",
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PrestasiDetailPage(prestasi: prestasi[index]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PrestasiForm())).then((value) {
            if (value == true && _userId != null) {
              // Jika nilai balik true, maka perbarui data prestasi
              setState(() {
                _futurePrestasi = fetchPrestasi(_userId!);
              });
            }
          });
        },
        icon: Icon(Icons.edit),
        label: Text('Tambah Prestasi'),
      ),
    );
  }
}
