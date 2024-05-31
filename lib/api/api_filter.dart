import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../main.dart';
import '../login.dart';

Response processResponse(Response response) {
  BuildContext context = navigatorKey.currentState!.context;
  if (response.statusCode == 200) {
    return response;
  }
  if (response.statusCode == 401) {
    showDialog(context: context, builder: (BuildContext context){
      return const AlertDialog(
        content: Text('토큰이 만료되었습니다. 다시 로그인해주세요.'),
      );
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }
  throw Exception('response status code : ${response.statusCode}');
}