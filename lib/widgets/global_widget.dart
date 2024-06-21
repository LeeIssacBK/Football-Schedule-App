

import 'package:flutter/material.dart';
import 'package:geolpo/dto/league_dto.dart';

Container getGlobalLine(String text, TextStyle style) {
  return Container(
      color: Colors.indigo,
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      height: 40.0,
      child: Row(
        children: [Text(text, style: style)],
      )
  );
}


Widget getLeagueTile(League? league) {
  return FilledButton(onPressed: () {},
      style: FilledButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: league!.type == 'LEAGUE' ? Colors.deepOrangeAccent : Colors.blue,
          minimumSize: const Size(10, 20),
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)
      ),
      child: Text(league.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))
  );
}

Widget getTile(Text text, Color color) {
  return FilledButton(onPressed: () {},
      style: FilledButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: color,
          minimumSize: const Size(10, 20),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0)
      ),
      child: text
  );
}