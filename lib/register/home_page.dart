import 'package:flutter/material.dart';
import 'package:projectone/register/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? nama = '';
  String? username = '';
  String? email = '';
  String? password = '';
  String? tanggalLahir = '';
  String? jenisKelamin = '';

  @override
  void initState() {
    super.initState();
    _getDataFromSharedPreferences();
  }

  Future<void> _getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama');
      username = prefs.getString('username');
      email = prefs.getString('email');
      password = prefs.getString('password');
      tanggalLahir = prefs.getString('tanggal_lahir');
      jenisKelamin = prefs.getString('jenis_kelamin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        // Tambahkan tombol kembali yang akan menavigasi ke tampilan login
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()), // Navigasi ke LoginPage
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Nama: $nama',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Username: $username',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Email: $email',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Password: $password',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Tanggal Lahir: $tanggalLahir',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Jenis Kelamin: $jenisKelamin',
            style: TextStyle(fontSize: 20),
          ),
          // Isi konten halaman lainnya di sini
        ],
      ),
    );
  }
}
