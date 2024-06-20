import 'package:flutter/material.dart';
import 'package:geolpo/qna.dart';
import 'package:geolpo/support.dart';
import 'package:geolpo/my_info.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/utils/pageRoute.dart';
import 'package:geolpo/widgets/global_widget.dart';
import 'package:intl/intl.dart';

import 'api/auth_api.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            getGlobalLine('마이페이지', getMainFont()),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  )
                )
              ),
              padding: const EdgeInsets.all(30.0),
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: Image.network(user!.profileImage ?? '').image,
                    backgroundColor: Colors.white,
                    radius: 80.0,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, globalPageRoute(MyInfo()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('내 정보', style: getMyPageFont())
                  )
                ],
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context, globalPageRoute(Qna()));              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Q & A', style: getMyPageFont())
                  )
                ],
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context, globalPageRoute(Support()));             },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('문의', style: getMyPageFont())
                  )
                ],
              ),
            ),

            InkWell(
              onTap: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('알림', style: getAlertDialogTitleStyle(),),
                    content: Text(
                        '로그아웃 하시겠습니까?', style: getAlertDialogContentStyle()),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton(
                                onPressed: () =>
                                    deleteToken().then((_) => logout()),
                                child: Text('예', style: getButtonTextColor(),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '아니오', style: getButtonTextColor(),)),
                          ),
                        ],
                      )
                    ],
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('로그아웃', style: getMyPageFont())
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  void logout() {
    auth = null;
    user = null;
    baseHeader = {};
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }

}