import 'package:flutter/material.dart';
import 'package:geolpo/global.dart';
import 'package:geolpo/mypage.dart';
import 'package:geolpo/search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'alarm.dart';
import 'home.dart';

class Navibar extends StatefulWidget {

  Navibar({required this.selectedIndex});

  late int selectedIndex;

  @override
  State<Navibar> createState() => _NavibarState(selectedIndex: selectedIndex);

}

class _NavibarState extends State<Navibar> {

  _NavibarState({required this.selectedIndex});

  late int selectedIndex;

  final List<Widget> _widgetOptions = [
    Home(), Search(), Alarm(), MyPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  void initState() {
    hasSubscribe().then((flag) {
      if (!flag) {
        setState(() {
          selectedIndex = 1;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return getTeamSearchAlert();
            },
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        child: SafeArea(
          child: _widgetOptions.elementAt(selectedIndex),
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
            icon: Icon(Icons.alarm),
            label: '알람 목록',
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
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<bool> hasSubscribe() async {
    final response = await http.get(Uri.parse('$baseUrl/api/subscribe/?type=TEAM'), headers: baseHeader);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      if (body is List && body.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  Widget getTeamSearchAlert() {
    return AlertDialog(
      title: const Text('알림', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.indigo)),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('현재 구독하고 있는 팀이 없습니다.'),
          Text('원하는 팀을 구독하고 알림을 받아보세요.'),
        ],
      ),
      contentTextStyle: const TextStyle(color: Colors.indigo),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인')),
          ),
        ),
      ],
    );
  }


}
