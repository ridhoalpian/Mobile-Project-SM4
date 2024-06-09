import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/database/DBHelper.dart';
import 'dart:convert';

import 'package:projectone/database/apiutils.dart';
import 'package:projectone/home/kegiatan/detail_kegiatan.dart';
import 'package:projectone/home/kegiatan/input_kegiatan.dart';

class KegiatanPage extends StatefulWidget {
  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  late Future<List<dynamic>> _futureKegiatan = Future.value([]); // Initialize with an empty future
  String _searchQuery = '';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    int? userId = await DBHelper.getUserId();
    if (userId != null) {
      setState(() {
        _userId = userId;
        _futureKegiatan = fetchKegiatan(_userId!);
      });
    } else {
      setState(() {
        _futureKegiatan = Future.error('User ID is null');
      });
    }
  }

  Future<List<dynamic>> fetchKegiatan(int userId) async {
    final response =
        await http.get(Uri.parse(ApiUtils.buildUrl('api/kegiatan/$userId')));

    if (response.statusCode == 200) {
      List<dynamic> kegiatan = json.decode(response.body);
      return kegiatan.reversed.toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshKegiatan() async {
    if (_userId != null) {
      setState(() {
        _futureKegiatan = fetchKegiatan(_userId!);
      });
    } else {
      setState(() {
        _futureKegiatan = Future.error('User ID is null');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshKegiatan,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Kegiatan',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
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
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _futureKegiatan,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<dynamic> kegiatan = snapshot.data!;
                        if (_searchQuery.isNotEmpty) {
                          kegiatan = kegiatan.where((item) {
                            final namakegiatan =
                                item['nama_kegiatan'].toString().toLowerCase();
                            final penanggungjawab = item['status_kegiatan']
                                .toString()
                                .toLowerCase();
                            return namakegiatan.contains(_searchQuery) ||
                                penanggungjawab.contains(_searchQuery);
                          }).toList();
                        }
                        return ListView.builder(
                          itemCount: kegiatan.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.cyan[50],
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.cyan[50],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Icon(Icons.calendar_month_rounded,
                                      size: 30, color: Colors.cyan),
                                ),
                                title: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.cyan[200],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    kegiatan[index]['nama_kegiatan'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                subtitle: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Status: ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: kegiatan[index]
                                              ['status_kegiatan'],
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
                                      builder: (context) => detailKegiatan(
                                        kegiatan: kegiatan[index],
                                        isEditable: kegiatan[index]['status_kegiatan'] ==
                                                'terkirim' ||
                                            kegiatan[index]['status_kegiatan'] ==
                                                'revisibem' ||
                                            kegiatan[index]['status_kegiatan'] ==
                                                'revisikemahasiswaan',
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value == true && _userId != null) {
                                      setState(() {
                                        _futureKegiatan =
                                            fetchKegiatan(_userId!);
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
                  MaterialPageRoute(builder: (context) => InputKegiatan(userId: _userId!)))
              .then((value) {
            if (value == true && _userId != null) {
              setState(() {
                _futureKegiatan = fetchKegiatan(_userId!);
              });
            }
          });
        },
        icon: Icon(Icons.add, color: Colors.black),
        label: Text(
          'Tambah Kegiatan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan[200],
      ),
    );
  }
}
