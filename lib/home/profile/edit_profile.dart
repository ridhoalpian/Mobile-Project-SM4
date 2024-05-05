import 'package:flutter/material.dart';
import 'package:projectone/database/DBHelper';

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  String emailUKM = '';
  String namaUKM = '';
  String namaKetua = '';

  // Controllers for TextFields
  TextEditingController _namaUKMController = TextEditingController();
  TextEditingController _emailUKMController = TextEditingController();
  TextEditingController _namaKetuaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    Map<String, dynamic> profileData = await DBHelper.getProfileData();

    setState(() {
      namaUKM = profileData['name'] ?? '';
      emailUKM = profileData['email'] ?? '';
      namaKetua = profileData['ketua'] ?? '';

      // Set text for TextFields using controllers
      _namaUKMController.text = namaUKM;
      _emailUKMController.text = emailUKM;
      _namaKetuaController.text = namaKetua;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _namaUKMController, // Use controller for this TextField
              decoration: InputDecoration(
                labelText: 'Nama UKM',
                prefixIcon: Icon(Icons.home, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailUKMController, // Use controller for this TextField
              decoration: InputDecoration(
                labelText: 'Email UKM',
                prefixIcon: Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _namaKetuaController, // Use controller for this TextField
              decoration: InputDecoration(
                labelText: 'Nama Ketua',
                prefixIcon: Icon(Icons.person, color: Colors.grey),
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
                onPressed: () {},
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
                  "Simpan Perubahan",
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