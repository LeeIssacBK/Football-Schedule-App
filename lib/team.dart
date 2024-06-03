

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dto/subscribe_dto.dart';
import 'styles/text_styles.dart';

class TeamInfo extends StatefulWidget {

  final Subscribe subscribe;
  const TeamInfo({super.key, required this.subscribe});

  @override
  State<TeamInfo> createState() => _TeamState();
}

class _TeamState extends State<TeamInfo> {

  late Subscribe subscribe;

  @override
  void initState() {
    super.initState();
    subscribe = widget.subscribe;
  }

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
                    child: Row(
                      children: [Text(subscribe.team!.krName ?? subscribe.team!.name, style: getMainFont()),],
                    )
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.network(subscribe.team!.logo),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text('소속 리그', style: getDetailFont(),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text('${subscribe.league?.name}', style: getDetailFont(),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text('연고지', style: getDetailFont(),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text('${subscribe.team!.city}', style: getDetailFont(),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text('창단', style: getDetailFont(),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text('${subscribe.team!.founded}', style: getDetailFont(),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text('선수단', style: getDetailFont(),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text('리그 순위', style: getDetailFont(),),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text('최근 5경기', style: getDetailFont(),),
                    ],
                  ),
                ),
                Row(
                  children: [Text('')],
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

}