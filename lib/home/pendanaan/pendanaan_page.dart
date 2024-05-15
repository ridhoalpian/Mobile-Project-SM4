import 'package:flutter/material.dart';

class DanaPage extends StatefulWidget {
  @override
  _DanaPageState createState() => _DanaPageState();
}

class _DanaPageState extends State<DanaPage> {
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.grey), // Warna border default
  );

  OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.grey), // Warna border saat diklik
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Text(
              'Dana anggaran tersisa: Rp. 15.000.000',
              style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.black12,
              thickness: 1,
              height: 30,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Anggaran Tersedia',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(Icons.money),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Anggaran Terpakai',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(Icons.money_off),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Anggaran Sisa',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Periode',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Status Anggaran',
                border: _outlineInputBorder,
                focusedBorder: _focusedBorder,
                prefixIcon: Icon(Icons.description),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
