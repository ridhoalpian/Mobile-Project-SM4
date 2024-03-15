import 'package:flutter/material.dart';
import 'package:projectone/register/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel untuk menyimpan data dari SharedPreferences
  String? nama = '';
  String? username = '';
  String? email = '';
  String? password = '';
  String? tanggalLahir = '';
  String? jenisKelamin = '';

  @override
  void initState() {
    super.initState();
    _getDataFromSharedPreferences(); // Memanggil fungsi untuk mendapatkan data dari SharedPreferences saat widget diinisialisasi
  }

  // Fungsi untuk mendapatkan data dari SharedPreferences
  Future<void> _getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Mengambil data dari SharedPreferences dan menyimpannya ke dalam variabel
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()), // Pindah ke halaman login saat tombol kembali ditekan
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Menampilkan data yang telah diambil dari SharedPreferences
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
        ],
      ),
    );
  }
}
