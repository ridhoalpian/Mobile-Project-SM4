import 'package:flutter/material.dart';
import 'package:projectone/login_register/login_page.dart';

class passBaru extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Password Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Password Baru',
                prefixIcon: Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                prefixIcon: Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF5F7C5D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                    side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  elevation: 10,
                  shadowColor: Colors.grey.withOpacity(0.2),
                ),
                child: Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
