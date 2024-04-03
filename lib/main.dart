import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.0)),
            child: Scaffold(
              backgroundColor: Colors.black12,
              body: Container(
                child: Column(
                  children: [
                    Expanded(child: SizedBox()),
                    Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/saedaegal.png'),
                        backgroundColor: Colors.black12,
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
                    Center(
                      child: Text("© Copyright 2024, 이병규",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            )));
  }
}
