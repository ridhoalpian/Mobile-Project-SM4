import 'package:flutter/material.dart';
import 'package:projectone/home/kegiatan/pengajuan.dart';

class KegiatanPage extends StatefulWidget {
  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Ini adalah halaman data kegiatan',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20.0,
            right: 16.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pengajuanKegiatan()),
                );
              },
              icon: Icon(Icons.edit),
              label: Text('Tambah Pengajuan Kegiatan'),
            ),
          ),
        ],
      ),
    );
  }
}
