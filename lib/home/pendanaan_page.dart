import 'package:flutter/material.dart';

class DanaPage extends StatefulWidget {
  @override
  _DanaPageState createState() => _DanaPageState();
}

class _DanaPageState extends State<DanaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Dana anggaran tersisa: Rp. 15.000.000',
              style: TextStyle(fontSize: 16),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1.5,
              height: 30,
            ),
            SizedBox(
                height: 20), // Berikan jarak antara garis pemisah dan TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Anggaran Tersedia',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10), // Berikan jarak antara TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Anggaran Terpakai',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10), // Berikan jarak antara TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Anggaran Sisa',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10), // Berikan jarak antara TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Periode ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10), // Berikan jarak antara TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Status Anggaran',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilePicker(BuildContext context) {
    // Open file picker dialog or navigator
  }
}
