import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectone/Models/UserData.dart';
import 'package:projectone/database/apiutils.dart';
import 'dart:convert';
import 'package:projectone/home/home_page.dart';
import 'package:projectone/database/DBHelper.dart';
import 'package:projectone/login_register/lupapassword_page.dart';
import 'package:projectone/login_register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  String email = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    if (widget.registeredEmail != null) {
      _emailUKMController.text = widget.registeredEmail!;
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(height: 20),
                Text(
                  'Tunggu Sebentar...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      );
      await fetchDataWithToken(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
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
    var headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(
      Uri.parse(ApiUtils.buildUrl('user-data')),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      UserData userData = UserData.fromJson(responseData);
      await DBHelper.insertUKMData(userData.toJson());
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(height: 20),
                Text(
                  'Tunggu Sebentar...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      );

      final response = await http.post(
        Uri.parse(ApiUtils.buildUrl('login')),
        body: {
          'email': email,
          'password': password,
        },
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['token'] != null) {
          String token = responseData['token'];
          await saveTokenToSharedPreferences(token);
          await fetchDataWithToken(token);

          List<Map<String, dynamic>> userDataList = await DBHelper.getUKMData();
          if (userDataList.isNotEmpty) {
            Map<String, dynamic> userDataMap = userDataList.first;
            String namaUKM = userDataMap['name']; // Assuming the key is 'name'

            AnimatedSnackBar.rectangle(
              'Success',
              'Selamat Datang $namaUKM',
              type: AnimatedSnackBarType.success,
              brightness: Brightness.light,
            ).show(context);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            AnimatedSnackBar.rectangle(
              'Info',
              'Email atau password salah',
              type: AnimatedSnackBarType.info,
              brightness: Brightness.light,
            ).show(context);
          }
        } else {
          AnimatedSnackBar.rectangle(
            'Info',
            'Email atau password salah',
            type: AnimatedSnackBarType.info,
            brightness: Brightness.light,
          ).show(context);
        }
      } else {
        AnimatedSnackBar.rectangle(
          'Info',
          'Email atau password salah',
          type: AnimatedSnackBarType.info,
          brightness: Brightness.light,
        ).show(context);
      }
    }
  }
}
