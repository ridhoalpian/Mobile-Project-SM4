import 'package:flutter/material.dart';

class detailLPJ extends StatelessWidget {
  final Map<String, dynamic> lpj;

  detailLPJ({required this.lpj});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail LPJ',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Height of the line
          child: Container(
            color: Colors.grey, // Color of the line
            height: 0.2, // Height of the line
          ),
        ),
        actions: [
            TextButton(
              onPressed: (){},
              child: Text(
                'Simpan',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama UKM: ${lpj['user_name']}'),
            SizedBox(height: 10),
            Text('Proker: ${lpj['nama_proker']}'),
            SizedBox(height: 10),
            Text('Penanggung Jawab: ${lpj['penanggung_jawab']}'),
            SizedBox(height: 10),
            Text('Uraian Proker: ${lpj['uraian_proker']}'),
            SizedBox(height: 10),
            Text('Periode: ${lpj['periode']}'),
            SizedBox(height: 10),
            Text('File LPJ: ${lpj['file_lpj']}'),
            SizedBox(height: 10),
            Text('Status lpj: ${lpj['status_lpj']}'),
          ],
        ),
      ),
    );
  }
}
