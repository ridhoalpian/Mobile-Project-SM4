import 'package:flutter/material.dart';

class detailKegiatan extends StatelessWidget {
  final Map<String, dynamic> kegiatan;

  detailKegiatan({required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kegiatan',
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
            Text('Nama Kegiatan: ${kegiatan['nama_kegiatan']}'),
            SizedBox(height: 10),
            Text('Penanggung Jawab: ${kegiatan['penanggung_jawab']}'),
            SizedBox(height: 10),
            Text('Pengajuan Dana: ${kegiatan['pengajuan_dana']}'),
            SizedBox(height: 10),
            Text('Dana Cair: ${kegiatan['dana_cair']}'),
            SizedBox(height: 10),
            Text('Periode: ${kegiatan['periode']}'),
            SizedBox(height: 10),
            Text('Proposal Kegiatan: ${kegiatan['proposal_kegiatan']}'),
            SizedBox(height: 10),
            Text('Status Kegiatan: ${kegiatan['status_kegiatan']}'),
          ],
        ),
      ),
    );
  }
}
