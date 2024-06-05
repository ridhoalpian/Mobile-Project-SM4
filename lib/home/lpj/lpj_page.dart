import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/database/DBHelper.dart';
import 'dart:convert';

import 'package:projectone/database/apiutils.dart';
import 'package:projectone/home/lpj/detail_lpj.dart';

class LpjPage extends StatefulWidget {
  @override
  _LpjPageState createState() => _LpjPageState();
}

class _LpjPageState extends State<LpjPage> {
  late Future<List<dynamic>> _futureLpj;
  String _searchQuery = '';
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
        _futureLpj = fetchLpj(_userId!);
      } else {
        // Handle null userId here, for example:
        _futureLpj = Future.error('User ID is null');
      }
    });
  }

  Future<List<dynamic>> fetchLpj(int userId) async {
    final response =
        await http.get(Uri.parse(ApiUtils.buildUrl('api/lpj/$userId')));

    if (response.statusCode == 200) {
      List<dynamic> lpj = json.decode(response.body);
      return lpj.reversed.toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshLpj() async {
    if (_userId != null) {
      setState(() {
        _futureLpj = fetchLpj(_userId!);
      });
    } else {
      // Handle null userId here, for example:
      _futureLpj = Future.error('User ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshLpj,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari LPJ',
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
                    future: _futureLpj,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<dynamic> lpj = snapshot.data!;
                        if (_searchQuery.isNotEmpty) {
                          lpj = lpj.where((item) {
                            final fileLpj =
                                item['nama_proker'].toString().toLowerCase();
                            final statusLpj =
                                item['status_lpj'].toString().toLowerCase();
                            return fileLpj.contains(_searchQuery) ||
                                statusLpj.contains(_searchQuery);
                          }).toList();
                        }
                        return ListView.builder(
                          itemCount: lpj.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.indigo[50],
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.indigo[50],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Icon(Icons.file_copy,
                                      size: 30, color: Colors.indigo),
                                ),
                                title: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.indigo[100],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    lpj[index]['nama_proker'],
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
                                          text: lpj[index]['status_lpj'],
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
                                      builder: (context) =>
                                          detailLPJ(lpj: lpj[index]),
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
          // Implementasikan aksi ketika tombol tambah LPJ ditekan, misalnya navigasi ke halaman input LPJ
        },
        icon: Icon(Icons.add, color: Colors.black),
        label: Text('Tambah LPJ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo[100],
      ),
    );
  }
}
