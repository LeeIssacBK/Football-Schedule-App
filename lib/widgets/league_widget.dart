

import 'package:flutter/material.dart';

import '../dto/league_dto.dart';

Widget getLeagueTile(League? league) {
  return FilledButton(onPressed: () {},
      style: FilledButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: league!.type == 'LEAGUE' ? Colors.deepOrangeAccent : Colors.blue,
          minimumSize: const Size(10, 20),
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)
      ),
      child: Text(league.name, style: const TextStyle(color: Colors.white, fontSize: 9))
  );
}