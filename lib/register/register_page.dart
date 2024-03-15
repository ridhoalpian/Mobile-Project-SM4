import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectone/register/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscured = true; // Variabel untuk mengontrol apakah password tersembunyi atau tidak
  TextEditingController _dateController = TextEditingController(); // Controller untuk field tanggal lahir
  TextEditingController _namaController = TextEditingController(); // Controller untuk field nama lengkap
  TextEditingController _usernameController = TextEditingController(); // Controller untuk field username
  TextEditingController _emailController = TextEditingController(); // Controller untuk field email
  TextEditingController _passwordController = TextEditingController(); // Controller untuk field password
  TextEditingController _confirmPasswordController = TextEditingController(); // Controller untuk field konfirmasi password
  String _selectedGender = 'laki'; // Variabel untuk menyimpan jenis kelamin yang dipilih

  // Fungsi untuk memeriksa apakah semua data registrasi telah diisi
  bool _isRegistrationDataComplete() {
    return _namaController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _dateController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Membungkus konten dalam SingleChildScrollView agar konten dapat di-scroll jika tidak muat dalam layar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Image.asset(
                'assets/images/logo_bem_polije.jpg',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Registrasi",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Textfield untuk nama lengkap
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap",
                ),
              ),
            ),
            // Textfield untuk username
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                ),
              ),
            ),
            // Textfield untuk email
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
              ),
            ),
            // Textfield untuk password
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: _isObscured
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured; // Mengubah status tersembunyi atau tidak password
                      });
                    },
                  ),
                ),
                obscureText: _isObscured, // Menyembunyikan atau menampilkan password tergantung dari status _isObscured
              ),
            ),
            // Textfield untuk konfirmasi password
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Konfirmasi Password",
                  suffixIcon: IconButton(
                    icon: _isObscured
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured; // Mengubah status tersembunyi atau tidak password
                      });
                    },
                  ),
                ),
                obscureText: _isObscured, // Menyembunyikan atau menampilkan password tergantung dari status _isObscured
              ),
            ),
            // Textfield untuk tanggal lahir
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                ),
                readOnly: true,
                onTap: () {
                  _selectedDate(); // Menampilkan date picker ketika textfield di-tap
                },
              ),
            ),
            SizedBox(height: 10),
            // Dropdown untuk memilih jenis kelamin
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!; // Mengubah jenis kelamin yang dipilih
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: 'laki',
                    child: Text('Laki-Laki'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'cewe',
                    child: Text('Perempuan'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                ),
              ),
            ),
            SizedBox(height: 20),
            // Tombol untuk melakukan registrasi
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_isRegistrationDataComplete()) { // Memeriksa apakah semua data registrasi telah diisi
                    _saveRegistrationData(); // Menyimpan data registrasi
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    // Tampilkan peringatan jika data belum lengkap
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Data Belum Lengkap"),
                          content: Text("Silakan lengkapi semua data registrasi."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Menutup dialog
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  primary: Color(0xFF5F7C5D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Daftar",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Tautan untuk login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sudah punya akun?",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0]; // Mengubah format tanggal yang dipilih
      });
    }
  }

  // Fungsi untuk menyimpan data registrasi ke SharedPreferences
  Future<void> _saveRegistrationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nama', _namaController.text);
    prefs.setString('username', _usernameController.text);
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setString('tanggal_lahir', _dateController.text);
    prefs.setString('jenis_kelamin', _selectedGender);
  }
}
