

import 'package:flutter/material.dart';
import 'package:geolpo/api/standing_api.dart';
import 'package:geolpo/api/subscribe_api.dart';
import 'package:geolpo/dto/standing_dto.dart';
import 'package:geolpo/navibar.dart';
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
                Container(
                    color: Colors.indigo,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5.0),
                    height: 40.0,
                    child: Row(
                      children: [
                        Text(subscribe.team!.krName ?? subscribe.team!.name, style: getMainFont()),
                        const Expanded(child: SizedBox()),
                        IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            padding: EdgeInsets.zero,
                            onPressed: () {

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('팀 구독 취소하기', style: getAlertDialogTitleStyle()),
                                      contentTextStyle: getAlertDialogContentStyle(),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('이미 추가된 경기 알람은 취소되지 않습니다.\n'
                                              '${subscribe.team!.krName ?? subscribe.team!.name} 의 구독을 취소하시겠습니까?'),
                                        ],
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  deleteSubscribe(subscribe.team!.apiId).then((flag) => {
                                                    if (flag) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('팀 구독이 취소 되었습니다!',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                            backgroundColor: Colors.teal,
                                                            duration: Duration(milliseconds: 3000),
                                                          )
                                                      )
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('구독 취소 실패! 다시 시도해 주세요.',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                            backgroundColor: Colors.redAccent,
                                                            duration: Duration(milliseconds: 1000),
                                                          )
                                                      )
                                                    }
                                                  }).then((_) => Navigator.of(context).pop())
                                                  .then((_) =>
                                                      Navigator.pushReplacement(context,
                                                          MaterialPageRoute(builder: (_) => Navibar(selectedIndex: 0))));
                                                },
                                                child: Text('예', style: getButtonTextColor()),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('아니오', style: getButtonTextColor()),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    );
                                  }
                                );
                            }
                        )
                      ],
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