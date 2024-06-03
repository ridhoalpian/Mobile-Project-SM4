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
  String namaUKM = '';
  String _searchQuery = '';

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
    final response = await http
        .get(Uri.parse(ApiUtils.buildUrl('api/prestasi?user_id=$userId')));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load prestasi');
    }
  }

  Future<void> _refreshPrestasi() async {
    setState(() {
      _futurePrestasi = fetchPrestasi(_userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshPrestasi,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Prestasi',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    fillColor: Colors.grey[200], // Light grey background color
                    filled: true, // Fills the background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none, // No border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none, // No border when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none, // No border when enabled
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 20),
                _userId == null
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: FutureBuilder<List<dynamic>>(
                          future: _futurePrestasi,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<dynamic> prestasi = snapshot.data!;
                              if (_searchQuery.isNotEmpty) {
                                prestasi = prestasi.where((item) {
                                  final namaLomba = item['namalomba']
                                      .toString()
                                      .toLowerCase();
                                  final statusPrestasi = item['statusprestasi']
                                      .toString()
                                      .toLowerCase();
                                  return namaLomba.contains(_searchQuery) ||
                                      statusPrestasi.contains(_searchQuery);
                                }).toList();
                              }
                              return ListView.builder(
                                itemCount: prestasi.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Colors.green[50],
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: ListTile(
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                          color:
                                              Colors.green[50], // Accent color
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Icon(Icons.emoji_events,
                                            size: 30, color: Colors.green),
                                      ),
                                      title: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded corners
                                          color:
                                              Colors.green[200], // Accent color
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          '[${prestasi[index]['juara']}] ${prestasi[index]['namalomba']}',
                                          style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      subtitle: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              20), // Rounded corners
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'status: ',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: prestasi[index]
                                                    ['statusprestasi'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PrestasiDetailPage(
                                              prestasi: prestasi[index],
                                              isEditable: prestasi[index]['statusprestasi'] != 'disetujui',
                                            ),
                                          ),
                                        ).then((value) {
                                          if (value == true && _userId != null) {
                                            setState(() {
                                              _futurePrestasi = fetchPrestasi(_userId!);
                                            });
                                          }
                                        });
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PrestasiForm()))
              .then((value) {
            if (value == true && _userId != null) {
              setState(() {
                _futurePrestasi = fetchPrestasi(_userId!);
              });
            }
          });
        },
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: Text('Tambah Prestasi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[600],
      ),
    );
  }
}
