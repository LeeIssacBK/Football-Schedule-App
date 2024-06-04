

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolpo/widgets/global_widget.dart';

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
                getGlobalLine(subscribe.team!.krName ?? subscribe.team!.name, getMainFont()),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.network(subscribe.team!.logo),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      getTile(Text('소속 리그', style: getDetailTitleFont()), Colors.indigo)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Image.network(subscribe.league!.logo, height: 20.0),
                      Expanded(child: Text(' ${subscribe.league?.name}', style: getDetailFont(),)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      getTile(Text('연고지', style: getDetailTitleFont()), Colors.indigo)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(child: Text('${subscribe.team!.city}', style: getDetailFont(),)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      getTile(Text('창단', style: getDetailTitleFont()), Colors.indigo)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(child: Text('${subscribe.team!.founded}', style: getDetailFont(),)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      getTile(Text('홈구장', style: getDetailTitleFont()), Colors.indigo)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(subscribe.team!.stadiumImage!),
                      Text(subscribe.team!.stadium ?? '정보없음', style: getDetailFont()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      getTile(Text('선수단', style: getDetailTitleFont()), Colors.indigo)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      getTile(Text('리그 순위', style: getDetailTitleFont()), Colors.indigo)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      getTile(Text('최근 5경기', style: getDetailTitleFont()), Colors.indigo)
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