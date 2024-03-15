import 'package:flutter/material.dart';
import 'package:projectone/register/home_page.dart';
import 'package:projectone/register/lupapassword_page.dart';
import 'package:projectone/register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true; // Variabel untuk mengontrol apakah password tersembunyi atau tidak
  TextEditingController _emailController = TextEditingController(); // Controller untuk field email
  TextEditingController _passwordController = TextEditingController(); // Controller untuk field password

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
              "Login",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Textfield untuk email
            Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 5),
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
              padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
              child: TextField(
                controller: _passwordController,
                obscureText: _isObscured, // Menyembunyikan atau menampilkan password tergantung dari status _isObscured
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
                      }),
                ),
              ),
            ),
            // Tautan untuk lupa password
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LupaPassword()),
                      );
                    },
                    child: Text(
                      "Lupa password?",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Tombol untuk melakukan login
            Container(
              padding: EdgeInsets.fromLTRB(40, 40, 40, 5),
              height: 100,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _login(); // Memanggil fungsi untuk melakukan login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5F7C5D),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Tautan untuk register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum punya akun?",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    " Register",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk melakukan login
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) { // Memeriksa apakah email dan password telah diisi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Isian Kosong"),
            content: Text("Silakan isi email dan password terlebih dahulu."),
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
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail == email && savedPassword == password) { // Memeriksa apakah email dan password yang dimasukkan sesuai dengan data yang disimpan
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Pindah ke halaman home jika login berhasil
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email atau Password Salah"),
            content: Text("Silakan coba lagi."),
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
  }
}
