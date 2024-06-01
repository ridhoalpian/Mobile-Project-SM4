import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:projectone/database/DBHelper.dart';
import 'package:projectone/database/apiutils.dart';
import 'package:projectone/home/proker/detail_proker.dart';
import 'package:projectone/home/proker/inputproker.dart';

class ProkerPage extends StatefulWidget {
  @override
  _ProkerPageState createState() => _ProkerPageState();
}

class _ProkerPageState extends State<ProkerPage> {
  late Future<List<dynamic>> _futureProker;
  late int _userId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    int? userId = await DBHelper.getUserId();
    setState(() {
      _userId = userId!;
      _futureProker = fetchProker(_userId);
    });
  }

  Future<List<dynamic>> fetchProker(int userId) async {
    final response = await http
        .get(Uri.parse(ApiUtils.buildUrl('api/proker?user_id=$userId')));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshProker() async {
    setState(() {
      _futureProker = fetchProker(_userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshProker,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Proker',
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
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 20),
                // ignore: unnecessary_null_comparison
                _userId == null
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: FutureBuilder<List<dynamic>>(
                          future: _futureProker,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<dynamic> proker = snapshot.data!;
                              if (_searchQuery.isNotEmpty) {
                                proker = proker.where((item) {
                                  return item['nama_proker']
                                      .toString()
                                      .toLowerCase()
                                      .contains(_searchQuery);
                                }).toList();
                              }
                              return ListView.builder(
                                itemCount: proker.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Colors.orange[50],
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: ListTile(
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                          color: Colors.orange[50],
                                          // Accent color
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Icon(Icons.book_rounded,
                                            size: 30, color: Colors.orange),
                                      ),
                                      title: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded corners
                                          color: Colors.orange[200],
                                          // Accent color
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          proker[index]['nama_proker'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            // Text color
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
                                                text: 'Status: ',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: proker[index]
                                                    ['status_proker'],
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
                                            builder: (context) => ProkerDetail(
                                              proker: proker[index],
                                              isEditable: proker[index]['statusprestasi'] != 'terkirim' && proker[index]['statusprestasi'] != 'ditolak',
                                            ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InputProker()))
              .then((value) {
            if (value == true) {
              setState(() {
                _futureProker = fetchProker(_userId);
              });
            }
          });
        },
        icon: Icon(
          Icons.edit,
          color: Colors.black,
        ),
        label: Text('Tambah Proker',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange[200],
      ),
    );
  }
}
