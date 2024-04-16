import 'package:flutter/material.dart';
import 'package:projectone/home/kegiatan/datakegiatan.dart';
import 'package:projectone/home/kegiatan/pengajuan.dart';

class KegiatanPage extends StatefulWidget {
  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = 0;
                      _pageController.animateToPage(_currentPage,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    });
                  },
                  style: TextButton.styleFrom(
                    primary: Color(0xFF5F7C5D),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                  child: Text('Pengajuan Kegiatan'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = 1;
                      _pageController.animateToPage(_currentPage,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    });
                  },
                  style: TextButton.styleFrom(
                    primary: Color(0xFF5F7C5D),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                  child: Text('Data Kegiatan'),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 5,
              color: _currentPage == 0 ? Color(0xFF5F7C5D) : Colors.transparent,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 5,
              color: _currentPage == 1 ? Color(0xFF5F7C5D) : Colors.transparent,
            ),
          ],
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              pengajuanKegiatan(),
              dataKegiatan(),
            ],
          ),
        ),
      ],
    );
  }
}
