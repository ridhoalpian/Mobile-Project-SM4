import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projectone/home/home_page.dart';
import 'package:projectone/database/DBHelper';
import 'package:projectone/login_register/lupapassword_page.dart';
import 'package:projectone/login_register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String? registeredEmail;

  const LoginPage({Key? key, this.registeredEmail}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  TextEditingController _emailUKMController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String emailUKM = '';
  String namaUKM = '';

  @override
  void initState() {
    super.initState();
    if (widget.registeredEmail != null) {
      _emailUKMController.text = widget.registeredEmail!;
    }
  }

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
              child: Image.asset(
                'assets/images/logo_bem_polije.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Login",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 5),
              child: TextFormField(
                controller: _emailUKMController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  labelText: "Email",
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
              padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
              child: TextFormField(
                controller: _passwordController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: _isObscured
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password harus diisi';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 10),
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
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 30, 40, 5),
              height: 90,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _login();
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
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum punya akun?",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600),
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
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
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

  Future<void> fetchDataWithToken(String token) async {
    // Tambahkan token ke dalam header permintaan
    var headers = {'Authorization': 'Bearer $token'};

    // Kirim permintaan ke API dengan menyertakan header yang berisi token
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/user-data'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Tangani respons dari API
      Map<String, dynamic> responseData = json.decode(response.body);
      // Simpan data pengguna pada DBHelper
      await DBHelper.insertUserData(responseData);
    } else {
      
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    String email = _emailUKMController.text.trim();
    String password = _passwordController.text.trim();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Tunggu Sebentar...'),
            ],
          ),
        );
      },
    );

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    Navigator.pop(context);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['token'] != null) {
        // Simpan token ke SharedPreferences
        String token = responseData['token'];
        await saveTokenToSharedPreferences(token);

        // Ambil data pengguna dari API
        await fetchDataWithToken(token);

        // Ambil nama UKM dari DBHelper
        Map<String, dynamic> userData = await DBHelper.getProfileData();
        String namaUKM = userData['name'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login berhasil! Selamat Datang $namaUKM'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email atau password salah."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal melakukan login."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
}
