import 'package:flutter/material.dart';
import 'package:geolpo/api/device_api.dart';
import 'package:geolpo/navibar.dart';
import 'package:geolpo/styles/text_styles.dart';

import 'api/auth_api.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {
                  kakaoLogin().then((_) {
                    return saveUserDeviceAndFcmToken();
                  }).then((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Navibar(selectedIndex: 0)));
                  }).catchError((error) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('알림', style: getAlertDialogTitleStyle()),
                          content: Text(exceptionMessage, style: getAlertDialogContentStyle()),
                          actions: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('확인', style: getButtonTextColor()),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Image(
                      image: AssetImage('image/kakao_login_medium_narrow.png'), width: 180,),
                ),
              ),
              IconButton(
                onPressed: () {
                  // naverLogin();
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('알림', style: getAlertDialogTitleStyle(),),
                      content: Text('서비스 준비중입니다.', style: getAlertDialogContentStyle()),
                      actions: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('확인', style: getButtonTextColor())),
                          ),
                        ),
                      ],
                    );
                  });
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Image(
                      image: AssetImage('image/naver_login_btnG.png'), width: 180),
                ),
              ),
              const Expanded(child: SizedBox()),
              const Padding(
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
        ),
      );
    });
  }

}
