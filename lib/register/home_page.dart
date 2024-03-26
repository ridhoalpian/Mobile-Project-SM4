import 'package:flutter/material.dart';
import 'package:projectone/register/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final User userData;

  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel untuk menyimpan data dari SharedPreferences
  String? namaUKM = '';
  String? username = '';
  String? emailUKM = '';
  String? password = '';
  String? bantuan = '';

  int _selectedIndex = 0;

  List<String> _appBarTitles = ['Proker', 'Kegiatan', 'Pendanaan', 'LPJ'];

  @override
  void initState() {
    super.initState();
    _getDataFromSharedPreferences(); // Memanggil fungsi untuk mendapatkan data dari SharedPreferences saat widget diinisialisasi
  }

  // Fungsi untuk mendapatkan data dari SharedPreferences
  Future<void> _getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Mengambil data dari SharedPreferences dan menyimpannya ke dalam variabel
      namaUKM = prefs.getString('namaUKM');
      username = prefs.getString('username');
      emailUKM = prefs.getString('emailUKM');
      password = prefs.getString('password');
      bantuan = prefs.getString('bantuan');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onProkerTap() {
    setState(() {
      _selectedIndex = 0;
    });
    Navigator.pop(context);
  }

  void _onKegiatanTap() {
    setState(() {
      _selectedIndex = 1;
    });
    Navigator.pop(context);
  }

  void _onPendanaanTap() {
    setState(() {
      _selectedIndex = 2;
    });
    Navigator.pop(context);
  }

  void _onLPJTap() {
    setState(() {
      _selectedIndex = 3;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
        backgroundColor: Color(0xFF5F7C5D),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF5F7C5D),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10), // Jarak antara "Profile" dan ikon
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 10), // Jarak antara icon dan teks
                      Text(
                        'Halo, ${widget.userData.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text('Proker'),
              onTap: () {
                _onProkerTap();
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Kegiatan'),
              onTap: () {
                _onKegiatanTap();
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Pendanaan'),
              onTap: () {
                _onPendanaanTap();
              },
            ),
            ListTile(
              leading: Icon(Icons.file_copy),
              title: Text('LPJ'),
              onTap: () {
                _onLPJTap();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.login_outlined),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     // Menampilkan data yang telah diambil dari SharedPreferences
      //     Text(
      //       'Nama: $namaUKM',
      //       style: TextStyle(fontSize: 20),
      //     ),
      //     SizedBox(height: 10),
      //     Text(
      //       'Username: $username',
      //       style: TextStyle(fontSize: 20),
      //     ),
      //     SizedBox(height: 10),
      //     Text(
      //       'Email: $emailUKM',
      //       style: TextStyle(fontSize: 20),
      //     ),
      //     SizedBox(height: 10),
      //     Text(
      //       'Password: $password',
      //       style: TextStyle(fontSize: 20),
      //     ),
      //     SizedBox(height: 10),
      //     Text(
      //       'Bantuan: $bantuan',
      //       style: TextStyle(fontSize: 20),
      //     ),
      //   ],
      // ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Widgets untuk tampilan Proker (index 0)
          Center(
            child: Text(
              'Tampilan Proker',
              style: TextStyle(fontSize: 20),
            ),
          ),
          // Widgets untuk tampilan Kegiatan (index 1)
          Center(
            child: Text(
              'Tampilan Kegiatan',
              style: TextStyle(fontSize: 20),
            ),
          ),
          // Widgets untuk tampilan Pendanaan (index 2)
          Center(
            child: Text(
              'Tampilan Pendanaan',
              style: TextStyle(fontSize: 20),
            ),
          ),
          // Widgets untuk tampilan LPJ (index 3)
          Center(
            child: Text(
              'Tampilan LPJ',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Proker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Kegiatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Pendanaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'LPJ',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
