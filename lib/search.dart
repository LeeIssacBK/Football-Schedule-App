


import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
    );
  }
}