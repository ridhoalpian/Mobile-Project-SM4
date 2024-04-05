import 'package:flutter/material.dart';
import 'package:projectone/login_register/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String emailUKM = '';
  String namaUKM = '';

  @override
  void initState() {
    super.initState();
    _loadRegistrationData();
  }

  Future<void> _loadRegistrationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      emailUKM = prefs.getString('emailUKM') ?? '';
      namaUKM = prefs.getString('namaUKM') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        0), // Atur jarak garis pinggir dari lingkaran
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Warna latar belakang circle avatar
                      border: Border.all(
                        color: Colors.white, // Warna garis pinggir
                        width: 5,
                        // Ketebalan garis pinggir
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Prabowo_Subianto%2C_Candidate_for_Indonesia%27s_President_in_2024.jpg/1200px-Prabowo_Subianto%2C_Candidate_for_Indonesia%27s_President_in_2024.jpg'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Warna garis pinggir
                          width: 3, // Ketebalan garis pinggir
                        ),
                        color: Color(0xFF5F7C5D),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Action when edit icon is pressed
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
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
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 192, 252, 179), // Warna latar belakang
                  borderRadius:
                      BorderRadius.circular(10), // Sudut yang membulat
                ),
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    username,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87, // Warna teks
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 5), // Berikan jarak antara dua teks
              Text(
                emailUKM,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87, // Warna teks
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Container(
                height: 60,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Action when button is pressed
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Optional: add border
                    ),
                    elevation: 40, // Elevasi
                    shadowColor: Colors.grey.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.edit_outlined,
                          color: Color(0xFF5F7C5D)), // Ikon sebagai prefix
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
                      SizedBox(width: 10), // Ikon sebagai suffix
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 60,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 40, // Elevasi
                    shadowColor: Colors.grey.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.lock_outline, color: Color(0xFF5F7C5D)),
                      SizedBox(width: 15), // Ikon sebagai prefix
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
                      SizedBox(width: 10), // Ikon sebagai suffix
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
                    _showLogoutConfirmationDialog(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 40, // Elevasi
                    shadowColor: Colors.grey.withOpacity(0.2), // Warna shadow
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.logout_outlined, color: Color(0xFF5F7C5D)),
                      SizedBox(width: 15), // Ikon sebagai prefix
                      Expanded(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.grey),
                      SizedBox(width: 10), // Ikon sebagai suffix
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
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
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
