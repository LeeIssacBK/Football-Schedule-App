import 'package:flutter/material.dart';
import 'routes/ScreenA.dart';
import 'routes/ScreenB.dart';
import 'routes/ScreenC.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (_) => ScreenA(),
        '/b' : (_) => ScreenB(),
        '/c' : (_) => ScreenC()
      },
    );
  }
}
