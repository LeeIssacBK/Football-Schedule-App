import 'dart:core';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dto/subscribe.dart';
import 'global.dart';
import 'package:http/http.dart' as http;

class Home2 extends StatefulWidget {
  @override
  State<Home2> createState() => _HomeState2();
}

class _HomeState2 extends State<Home2> {
  int sliderIndex = 0;
  List<Subscribe>? subscribeTeams;

  @override
  void initState() {
    getSubscribes().then((_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  color: Colors.indigo,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  height: 40.0,
                  child: const Text('내 팀',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold))),
              subscribeTeams != null ?
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    slider(screenHeight / 3.7),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: indicator(subscribeTeams),
                      ),
                    ),
                  ],
                ),
              ) : const CircularProgressIndicator(),
              Container(
                  color: Colors.indigo,
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  child: const Text('경기 일정', style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold))
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getSubscribes() async {
    final response = await http.get(Uri.parse('$baseUrl/api/subscribe/?type=TEAM'), headers: baseHeader);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      if (body is List && body.isNotEmpty) {
        subscribeTeams = List<Subscribe>.from(json.decode(response.body).map((_) => Subscribe.fromJson(_)));
      }
    }
  }

  Widget slider(height) {
    List<Column>? images = subscribeTeams!.map((subscribe) {
      return Column(
        children: [
          Image.network(subscribe.team!.logo),
          Text(subscribe.team!.name, style: const TextStyle(color: Colors.indigo, fontSize: 20.0, fontWeight: FontWeight.bold)),
        ],
      );
    }).toList();
    return CarouselSlider(
      items: images,
      options: CarouselOptions(
        height: height,
        autoPlay: false,
        viewportFraction: 1,
        enlargeCenterPage: true,
        initialPage: 0,
        onPageChanged: (index, reason) => setState(() {
          sliderIndex = index;
        }),
      )
    );
  }

// Indicator
  Widget indicator(subscribeTeams) => Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: sliderIndex,
        count: subscribeTeams.length,
        effect: JumpingDotEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: Colors.grey,
            dotColor: Colors.grey.withOpacity(0.6)),
      ));

}