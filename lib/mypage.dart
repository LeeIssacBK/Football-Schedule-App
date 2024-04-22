import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _SearchState();
}

class _SearchState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('MyPage PAGE', style: TextStyle(fontSize: 50.0),),
    );
  }

}