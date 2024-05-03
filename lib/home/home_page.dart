import 'package:flutter/material.dart';
import 'package:projectone/home/kegiatan/kegiatan_page.dart';
import 'package:projectone/home/lpj/lpj_page.dart';
import 'package:projectone/home/pendanaan/pendanaan_page.dart';
import 'package:projectone/home/profile/profile_page.dart';
import 'package:projectone/home/proker/proker_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
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
  Widget build(BuildContext context) {
    return Scaffold(
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
