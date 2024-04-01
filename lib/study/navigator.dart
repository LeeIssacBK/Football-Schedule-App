import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext firstPageContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First page'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            Navigator.push(firstPageContext, MaterialPageRoute(
                builder: (context) => SecondPage()));
          },
          child: Text('go to the second page'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext secondPageContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second page'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            Navigator.pop(secondPageContext);
          },
          child: Text('go to the first page'),
        ),
      ),
    );
  }
}