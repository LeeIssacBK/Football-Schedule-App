import 'package:flutter/material.dart';
import 'package:geolpo/api/search_api.dart';
import 'package:geolpo/dto/team_dto.dart';
import 'package:geolpo/navibar.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/widgets/global_widget.dart';

class SearchTeam extends StatefulWidget {
  final int leagueId;

  const SearchTeam({super.key, required this.leagueId});

  @override
  State<StatefulWidget> createState() => _SearchTeam();
}

class _SearchTeam extends State<SearchTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            getGlobalLine('팀 선택', getMainFont()),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<Team>>(
                    future: getTeams(widget.leagueId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      List<Team> teams = snapshot.data!;
                      if (teams.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 100.0,),
                            Text('팀 정보를 찾을 수 없습니다.', style: getSearchFont(),),
                          ],
                        );
                      }
                      return Column(
                        children: teams.map((team) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('팀 구독', style: getAlertDialogTitleStyle()),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(padding: const EdgeInsets.all(30.0), child: Image.network(team.logo)),
                                              Container(padding: const EdgeInsets.all(5.0), child: Text('${team.krName ?? team.name}을(를) 구독하시겠습니까?')),
                                            ],
                                          ),
                                          contentTextStyle: getAlertDialogContentStyle(),
                                          actions: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          subscribeTeam(team.apiId).then((_) =>
                                                              Navigator.of(context).pop()).then((_) =>
                                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Navibar(selectedIndex: 0,)))
                                                          );
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            content: Text(
                                                              '팀 구독이 완료되었습니다.',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                            backgroundColor: Colors.teal,
                                                            duration: Duration(milliseconds: 3000),
                                                          ));
                                                        }, child: Text('예', style: getButtonTextColor(),)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('아니오', style: getButtonTextColor(),)),
                                                  ),
                                                ]),
                                          ],
                                        );
                                      }
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(team.krName ?? team.name, style: getSearchFont())
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  )
                )
              )
            )
          ],
        ),
      ),
    );
  }
}
