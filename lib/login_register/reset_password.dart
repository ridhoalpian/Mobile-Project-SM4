import 'package:flutter/material.dart';

class reset_password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            "Reset Password",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Password Baru",
              ),
            ),
          ),
          // Masukkan TextField lainnya di sini
          Container(
            padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Konfirmasi Password Baru",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 40, 40, 5),
            height: 100,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: Color(0xFF5F7C5D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Reset Password",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}