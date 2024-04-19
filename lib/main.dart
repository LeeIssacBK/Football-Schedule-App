import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '6ef65107292ada731123dac02c2d72bc');
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(fontFamily: ''),
      themeMode: ThemeMode.system,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return PopScope(
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: const Scaffold(
                  backgroundColor: Colors.blueGrey,
                  body: Column(
                    children: [
                      Expanded(child: SizedBox()),
                      Center(
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/saedaegal.png'),
                          backgroundColor: Colors.blueGrey,
                          radius: 60.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Text(
                          'Football Scheduler',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("© Copyright 2024, 이병규",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                )));
      }
    );
  }
}
