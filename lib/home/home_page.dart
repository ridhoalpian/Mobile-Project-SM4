import 'package:flutter/material.dart';
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
    'Program Kerja',
    'Pengajuan Kegiatan',
    'History Pendanaan',
    'Lembar Penanggung Jawaban',
    'Profile'
  ];

  @override
  void initState() {
    super.initState();
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
          color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
      backgroundColor: Color(0xFF5F7C5D),
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
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
              'Tampilan Proker',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Center(
            child: Text(
              'Tampilan Kegiatan',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Center(
            child: Text(
              'Tampilan Pendanaan',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Center(
            child: Text(
              'Tampilan LPJ',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Center(
            child: Text(
              'Tampilan Profile',
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
