import 'package:flutter/material.dart';
import 'package:projectone/home/lpj/pengajuanlpj.dart';

class LpjPage extends StatefulWidget {
  @override
  _LpjPageState createState() => _LpjPageState();
}

class _LpjPageState extends State<LpjPage> {
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
          'Ini adalah halaman data lpj',
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
                  MaterialPageRoute(builder: (context) => pengajuanLpj()),
                );
              },
              icon: Icon(Icons.edit),
              label: Text('Tambah Pengajuan LPJ'),
            ),
          ),
        ],
      ),
    );
  }
}
