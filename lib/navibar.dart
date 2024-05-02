import 'package:flutter/material.dart';
import 'package:geolpo/home.dart';
import 'package:geolpo/mypage.dart';
import 'package:geolpo/search.dart';

import 'alert.dart';
import 'home2.dart';

class Navibar extends StatefulWidget {
  @override
  State<Navibar> createState() => _NavibarState();
}

class _NavibarState extends State<Navibar> {

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    Home2(), Search(), Alert(), MyPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.find_replace),
            label: '팀 찾기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert),
            label: '알람 설정',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '마이페이지',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.indigo,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
