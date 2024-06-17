

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolpo/api/standing_api.dart';
import 'package:geolpo/dto/standing_dto.dart';
import 'package:geolpo/utils/parser.dart';
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
  Standing? standing;

  @override
  void initState() {
    super.initState();
    subscribe = widget.subscribe;
    getStanding(subscribe.team!.apiId)
        .then((_) => standing = (_))
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
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
                      Column(
                        children: [
                          getTile(Text('리그 순위', style: getDetailTitleFont()), Colors.indigo),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${standing?.rank ?? '정보없음'}${standing?.rank != null ? '위' : ''}', style: getDetailFont(),),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      Column(
                        children: [
                          getTile(Text('최근 5경기', style: getDetailTitleFont()), Colors.indigo),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(standing?.form != null ? getKoreanStanding(standing!.form) : '정보없음', style: getDetailFont(),),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      Column(
                        children: [
                          getTile(Text('시즌 전적', style: getDetailTitleFont()), Colors.indigo),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${standing?.all.win}승 ${standing?.all.draw}무 ${standing?.all.lose}패', style: getDetailFont(),),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

}