import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:projectone/database/DBHelper.dart';
import 'package:projectone/database/apiutils.dart';

class DanaPage extends StatefulWidget {
  @override
  _DanaPageState createState() => _DanaPageState();
}

class _DanaPageState extends State<DanaPage> {
  late Future<Map<String, dynamic>> futurePendanaan;
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
        futurePendanaan = fetchPendanaan(_userId!);
      }
    });
  }

  String formatRupiah(dynamic amount) {
    if (amount == null) {
      return 'Rp. 0';
    }
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return formatter.format(amount);
  }

  Future<Map<String, dynamic>> fetchPendanaan(int userId) async {
    final response = await http
        .get(Uri.parse(ApiUtils.buildUrl('api/pendanaan?user_id=$userId')));

    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      throw Exception('Failed to load pendanaan');
    }
  }

  Future<void> _refreshData() async {
    if (_userId != null) {
      setState(() {
        futurePendanaan = fetchPendanaan(_userId!);
      });
    }
  }

  InputDecoration _buildDropDownDecoration(
      {String? labelText, IconData? prefixIcon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey),
      border: InputBorder.none,
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _userId == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
              future: futurePendanaan,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Infromasi Dana',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24), 
                          ),
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/images/pendanaan_ilustrasi.jpg',
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            initialValue: formatRupiah(
                                snapshot.data!['anggaran_tersedia']),
                            decoration: _buildDropDownDecoration(
                              labelText: 'Anggaran Tersedia',
                              prefixIcon: Icons.money,
                            ),
                            readOnly: true,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            initialValue:
                                formatRupiah(snapshot.data!['total_dana']),
                            decoration: _buildDropDownDecoration(
                              labelText: 'Anggaran Terpakai',
                              prefixIcon: Icons.money,
                            ),
                            readOnly: true,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            initialValue:
                                formatRupiah(snapshot.data!['sisa_anggaran']),
                            decoration: _buildDropDownDecoration(
                              labelText: 'Anggaran Sisa',
                              prefixIcon: Icons.money,
                            ),
                            readOnly: true,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            initialValue: snapshot.data!['periode'],
                            decoration: _buildDropDownDecoration(
                              labelText: 'Periode',
                              prefixIcon: Icons.calendar_today,
                            ),
                            readOnly: true,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            initialValue: snapshot.data!['status_anggaran'],
                            decoration: _buildDropDownDecoration(
                              labelText: 'Status Anggaran',
                              prefixIcon: Icons.description,
                            ),
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
    );
  }
}
