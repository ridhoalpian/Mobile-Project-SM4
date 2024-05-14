import 'package:flutter/material.dart';
import 'package:projectone/Models/UserData.dart';
import 'package:projectone/database/DBHelper.dart';
import 'package:projectone/home/dashboard/dashboard_page.dart';
import 'package:projectone/home/kegiatan/kegiatan_page.dart';
import 'package:projectone/home/lpj/lpj_page.dart';
import 'package:projectone/home/pendanaan/pendanaan_page.dart';
import 'package:projectone/home/prestasi/prestasi_page.dart';
import 'package:projectone/home/profile/profile_page.dart';
import 'package:projectone/home/proker/proker_page.dart';
import 'package:projectone/login_register/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
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
    } else {
      // Handle case when no profile data is found
    }
  }

  List<String> _menuTitles = [
    'Dashboard',
    'Program Kerja',
    'Kegiatan',
    'Prestasi',
    'Pendanaan',
    'Lembar Penanggung Jawaban',
    'Pengaturan Profile',
    'Logout'
  ];

  List<IconData> _icons = [
    Icons.dashboard_customize_rounded,
    Icons.book_rounded,
    Icons.calendar_month_rounded,
    Icons.emoji_events,
    Icons.monetization_on,
    Icons.file_copy_rounded,
    Icons.settings,
    Icons.logout_outlined
  ];

  List<Color> _iconColors = [
    Colors.red,
    Colors.orange,
    Colors.cyan,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.teal
  ];

  List<Widget> _pages = [
    DashboarPage(),
    ProkerPage(),
    KegiatanPage(),
    PrestasiPage(),
    DanaPage(),
    LpjPage(),
    ProfilePage(),
  ];

  void _onDrawerItemTapped(int index) {
    if (index == 7) {
      _showLogoutConfirmationDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pop(context); // Menutup drawer setelah item dipilih
    }
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
              // Hapus token dari SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_menuTitles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            SizedBox(height: 80),
            Icon(
              Icons.account_circle,
              size: 80,
              color: Colors.green[200],
            ),
            SizedBox(height: 10),
            Text(
              namaUKM,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              emailUKM,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey, // Warna garis
              thickness: 1, // Ketebalan garis
              indent: 15, // Indentasi dari kiri
              endIndent: 15, // Indentasi dari kanan
            ),
            for (var i = 0; i < _menuTitles.length; i++)
              Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[50],
                      child: Icon(_icons[i], color: _iconColors[i]),
                    ),
                    title: Text(
                      _menuTitles[i],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    onTap: () => _onDrawerItemTapped(i),
                  ),
                  if (i == 5)
                    Divider(
                      color: Colors.grey, // Warna garis
                      thickness: 1, // Ketebalan garis
                      indent: 15, // Indentasi dari kiri
                      endIndent: 15, // Indentasi dari kanan
                    ),
                ],
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
