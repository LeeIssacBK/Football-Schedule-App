import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            Text('HOME', style: TextStyle(color: Colors.white),),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.home))),
                Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.find_replace))),
                Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.face))),
              ],
            )
          ],
        ),
      ),
    );
  }

}