import 'package:flutter/material.dart';
import 'package:geolpo/home.dart';
import 'package:geolpo/mypage.dart';
import 'package:geolpo/search.dart';

class Navibar extends StatefulWidget {
  @override
  State<Navibar> createState() => _NavibarState();
}

class _NavibarState extends State<Navibar> {

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    Home(), Search(), MyPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.find_replace),
              label: '검색'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '마이페이지'
          ),
        ],
        selectedItemColor: Colors.blueGrey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
