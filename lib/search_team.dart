

import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              getGlobalLine('팀 선택', getMainFont()),
            ],
          ),
        ),
      ),
    );
  }

}