import 'package:flutter/material.dart';
import 'dice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice game',
      home: LogIn(),
    );
  }
}

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  // dispose method

  bool isPass(
      TextEditingController controller, TextEditingController controller2) {
    return controller.text == 'dice' && controller2.text == '1234';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Center(
                    child: Image(
                      image: AssetImage('image/saedaegal_party.gif'),
                      width: 190.0,
                      height: 190.0,
                    ),
                  ),
                  Form(
                      child: Theme(
                    data: ThemeData(
                        primaryColor: Colors.teal,
                        inputDecorationTheme: InputDecorationTheme(
                            labelStyle:
                                TextStyle(color: Colors.teal, fontSize: 15.0))),
                    child: Container(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          TextField(
                            autofocus: true,
                            controller: controller,
                            decoration:
                                InputDecoration(labelText: 'Enter "dice"'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            controller: controller2,
                            decoration:
                                InputDecoration(labelText: 'Enter Password'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          SizedBox(height: 40.0),
                          ElevatedButton(
                            child: Icon(Icons.arrow_forward,
                                color: Colors.white, size: 35.0),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 50),
                                backgroundColor: Colors.orangeAccent),
                            onPressed: () {
                              if (isPass(controller, controller2)) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => Dice()));
                              } else {
                                showSnackBar(context);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('check your id or password',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.blue,
    duration: Duration(milliseconds: 2000),
  ));
}
