import 'package:flutter/material.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:http/http.dart';

import '../main.dart';
import '../login.dart';
import '../navibar.dart';

Response processResponse(Response response) {
  BuildContext context = navigatorKey.currentState!.context;
  if (response.statusCode == 200) {
    return response;
  }
  if (response.statusCode == 401) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('알림', style: getAlertDialogTitleStyle(),),
        content: Text('토큰이 만료되었습니다.\n다시 로그인해주세요.', style: getAlertDialogContentStyle()),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text('확인', style: getButtonTextColor())),
            ),
          ),
        ],
      );
    });
  }
  if (response.statusCode >= 500) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('알림', style: getAlertDialogTitleStyle(),),
        content: Text('홈 화면으로 돌아갑니다. 잠시후 다시 시도해주세요.', style: getAlertDialogContentStyle()),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navibar(selectedIndex: 0,)));
                  },
                  child: Text('확인', style: getButtonTextColor())),
            ),
          ),
        ],
      );
    });
  }
  return response;
}