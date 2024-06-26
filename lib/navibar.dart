import 'package:flutter/material.dart';
import 'package:geolpo/api/auth_api.dart';
import 'package:geolpo/mypage.dart';
import 'package:geolpo/search.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'alarm.dart';
import 'calendar.dart';
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
    Home(), Search(), Alarm(), Calendar(), MyPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (selectedIndex != 0) {
      setState(() {
        selectedIndex = 0;
      });
      return false;
    } else {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you really want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        ),
      ) ?? false;
    }
  }

  @override
  void initState() {
    super.initState();
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
            icon: Icon(Icons.calendar_month),
            label: '달력',
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
      title: Text('알림', style: getAlertDialogTitleStyle()),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('현재 구독하고 있는 팀이 없습니다.'),
          Text('원하는 팀을 구독하고 알림을 받아보세요.'),
        ],
      ),
      contentTextStyle: getAlertDialogContentStyle(),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인', style: getButtonTextColor())),
          ),
        ),
      ],
    );
  }


}
