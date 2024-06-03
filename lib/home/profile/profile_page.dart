import 'package:flutter/material.dart';
import 'package:projectone/Models/UserData.dart';
import 'package:projectone/database/DBHelper.dart';
import 'package:projectone/home/profile/edit_profile.dart';
import 'package:projectone/home/profile/ganti_password.dart';
import 'package:projectone/login_register/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String emailUKM = '';
  String namaUKM = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    List<Map<String, dynamic>> profileDataList = await DBHelper.getUKMData();

    if (profileDataList.isNotEmpty) {
      Map<String, dynamic> profileDataMap = profileDataList.first;
      UserData profileData = UserData.fromJson(profileDataMap);

      setState(() {
        namaUKM = profileData.name;
        emailUKM = profileData.email;
      });
    } else {}
  }

  Future<void> _refreshData() async {
    await _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 100), // Menambahkan SizedBox dengan tinggi 100
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/logo_polije.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                namaUKM,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 7),
              Text(
                emailUKM,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Container(
                height: 60,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    ).then((_) {
                      _loadProfileData();
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    ),
                    elevation: 10,
                    shadowColor: Colors.grey.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.edit_outlined, color: Color(0xFF5F7C5D)),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.grey),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 60,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GantiPassword()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    ),
                    elevation: 10,
                    shadowColor: Colors.grey.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.lock_outline, color: Color(0xFF5F7C5D)),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          "Ganti Password",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.grey),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Yakin ingin keluar?"),
          actions: <Widget>[
            TextButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text("Ya"),
              onPressed: () async {
                // Hapus data dari database SQFlite
                await DBHelper.deleteUKMData();

                // Tutup dialog
                Navigator.of(context).pop();

                // Arahkan pengguna kembali ke halaman login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
