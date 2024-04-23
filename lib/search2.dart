import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dto/country.dart';
import 'global.dart';

class Search2 extends StatefulWidget {

  final Continent data;

  Search2({required this.data});

  @override
  State<Search2> createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  Continent? continent;
  List<Country>? countries;

  @override
  void initState() {
    super.initState();
    continent = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(continent.toString()),
      ),
    );
  }

}