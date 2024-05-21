import 'package:flutter/material.dart';
import 'package:projectone/database/apiutils.dart';

// ignore: must_be_immutable
class PrestasiDetailPage extends StatelessWidget {
  final Map<String, dynamic> prestasi;

  PrestasiDetailPage({required this.prestasi});

  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.grey),
  );

  OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Prestasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '[${prestasi['juara']}] ${prestasi['namalomba']}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTextField('Status Prestasi', prestasi['statusprestasi']),
              _buildTextField('Kategori Lomba', prestasi['kategorilomba']),
              _buildTextField('Tanggal Perlombaan', prestasi['tanggallomba']),
              _buildTextField('Penyelenggara', prestasi['penyelenggara']),
              _buildTextField('Lingkup', prestasi['lingkup']),
              SizedBox(height: 20),
              Text(
                'Sertifikat:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Image.network(
                ApiUtils.buildUrl('storage/${prestasi['sertifikat']}'),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text(
                'Dokumentasi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Image.network(
                ApiUtils.buildUrl('storage/${prestasi['dokumentasi']}'),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: initialValue,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: _outlineInputBorder,
          focusedBorder: _focusedBorder,
        ),
      ),
    );
  }
}
