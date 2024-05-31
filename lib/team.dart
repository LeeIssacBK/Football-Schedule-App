

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeamInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TeamState();
}

class _TeamState extends State<TeamInfo> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    color: Colors.indigo,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5.0),
                    height: 40.0,
                    child: const Row(
                      children: [
                        Text('ㅎㅎ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

}