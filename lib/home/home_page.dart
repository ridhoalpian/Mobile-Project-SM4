import 'package:flutter/material.dart';
import 'package:projectone/home/kegiatan_page.dart';
import 'package:projectone/home/lpj_page.dart';
import 'package:projectone/home/pendanaan_page.dart';
import 'package:projectone/home/profile_page.dart';
import 'package:projectone/home/proker_page.dart';
import 'package:projectone/login_register/login_page.dart';

class HomePage extends StatefulWidget {
  final User userData;

  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<String> _appBarTitles = [
    'Dashboard',
    'Program Kerja',
    'Pengajuan Kegiatan',
    'History Pendanaan',
    'Lembar Pertanggung Jawaban',
    'Profile'
  ];
  
  List<String> _menuTitles = [
    'Dashboard',
    'Proker',
    'Kegiatan',
    'Pendanaan',
    'LPJ',
    'Profile'
  ];

  List<IconData> _icons = [
    Icons.dashboard_customize_rounded, // Default icon
    Icons.book_rounded,
    Icons.calendar_month_rounded,
    Icons.monetization_on,
    Icons.file_copy_rounded,
    Icons.person_2_rounded,
  ];

  List<IconData> _selectedIcons = [
    Icons.dashboard_customize_outlined,
    Icons.book_outlined,
    Icons.calendar_month_outlined,
    Icons.monetization_on_outlined,
    Icons.file_copy_outlined,
    Icons.person_2_outlined,
  ];

  List<IconData> _originalIcons = [
    Icons.dashboard_customize_outlined,
    Icons.book_outlined,
    Icons.calendar_month_outlined,
    Icons.monetization_on_outlined,
    Icons.file_copy_outlined,
    Icons.person_2_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIcons = List<IconData>.from(_originalIcons);
    _selectedIcons[0] = _icons[0];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(_appBarTitles[_selectedIndex]),
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Color(0xFF5F7C5D)),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 1.5,
          height: 30,
        )
      ],
    );
  }

  AppBar _buildSearchBar() {
    return AppBar(
      backgroundColor: Color(0xFF5F7C5D),
      iconTheme: IconThemeData(color: Colors.white),
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
              color: Colors.white, fontSize: 21, fontFamily: 'Montserrat'),
        ),
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontFamily: 'Montserrat'),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchBar() : _buildAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Center(
            child: Text(
              'Tampilan Dashboard',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ProkerPage(),
          KegiatanPage(),
          DanaPage(),
          LpjPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(
          _menuTitles.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(_selectedIcons[index]),
            label: _menuTitles[index],
          ),
        ),
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // Reset selected icons to the original state
            _selectedIcons = List<IconData>.from(_originalIcons);
            // Change the selected icon
            _selectedIcons[index] = _icons[index];
          });
        },
      ),
    );
  }
}
