import 'package:flutter/material.dart';
import 'package:projectone/home/proker/inputproker.dart';

class ProkerPage extends StatefulWidget {
  @override
  _ProkerPageState createState() => _ProkerPageState();
}

class _ProkerPageState extends State<ProkerPage> {
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
          'Ini adalah halaman data proker',
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
                  MaterialPageRoute(builder: (context) => InputProker()),
                );
              },
              icon: Icon(Icons.edit),
              label: Text('Tambah Proker'),
            ),
          ),
        ],
      ),
    );
  }
}
