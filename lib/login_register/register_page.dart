import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectone/login_register/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  // Variabel untuk mengontrol apakah password tersembunyi atau tidak

  TextEditingController _usernameController =
      TextEditingController(); // Controller untuk field username
  TextEditingController _emailUKMController =
      TextEditingController(); // Controller untuk field email
  TextEditingController _namaUKMController =
      TextEditingController(); // Controller untuk field nama lengkap
  TextEditingController _passwordController =
      TextEditingController(); // Controller untuk field password
  TextEditingController _confirmPasswordController =
      TextEditingController(); // Controller untuk field konfirmasi password
  TextEditingController _bantuanPassController =
      TextEditingController(); // Controller untuk field bantuan lupa password

  // Fungsi untuk memeriksa apakah semua data registrasi telah diisi
  bool _isRegistrationDataComplete() {
    return _namaUKMController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _emailUKMController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _bantuanPassController.text.isNotEmpty;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
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
                Container(
                  // Textfield untuk username
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  // Textfield untuk email
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _emailUKMController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email harus diisi';
                      }
                      // Pattern untuk memeriksa apakah nilai adalah email yang valid
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Masukkan alamat email yang valid';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  // Textfield untuk Nama UKM
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _namaUKMController,
                    decoration: InputDecoration(
                      labelText: "Nama UKM",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama UKM harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  // Textfield untuk password
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText:
                        _isPasswordObscured, // Menyembunyikan atau menampilkan password tergantung dari status _isObscured
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: _isPasswordObscured
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured =
                                !_isPasswordObscured; // Mengubah status tersembunyi atau tidak password
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password harus diisi';
                      }
                      if (value.length < 8) {
                        return 'Password harus memiliki setidaknya 8 karakter';
                      }
                      return null;
                    },
                  ),
                ),
                // Textfield untuk konfirmasi password
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText:
                        _isConfirmPasswordObscured, // Menyembunyikan atau menampilkan password tergantung dari status _isObscured
                    decoration: InputDecoration(
                      labelText: "Konfirmasi Password",
                      suffixIcon: IconButton(
                        icon: _isConfirmPasswordObscured
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordObscured =
                                !_isConfirmPasswordObscured; // Mengubah status tersembunyi atau tidak password
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password harus diisi';
                      }
                      if (value.length < 8) {
                        return 'Password harus memiliki setidaknya 8 karakter';
                      }
                      if (value != _passwordController.text) {
                        return 'Konfirmasi password tidak sesuai';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _bantuanPassController,
                    decoration: InputDecoration(
                      labelText: "Bantuan Lupa Password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bantuan Lupa Password harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 40),
                // Tombol untuk melakukan registrasi
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pemicu validasi ketika tombol ditekan

                      if (_formKey.currentState!.validate()) {
                        // Jika validasi berhasil
                        _saveRegistrationData();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
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
                        fontFamily: 'Montserrat'
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
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            )));
  }

  // Fungsi untuk menyimpan data registrasi ke SharedPreferences
  Future<void> _saveRegistrationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
    prefs.setString('emailUKM', _emailUKMController.text);
    prefs.setString('namaUKM', _namaUKMController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setString('bantuan', _bantuanPassController.text);
  }
}
