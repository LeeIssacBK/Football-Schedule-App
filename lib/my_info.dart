import 'package:flutter/material.dart';
import 'package:geolpo/api/auth_api.dart';
import 'package:geolpo/api/mypage_api.dart';
import 'package:geolpo/dto/myinfo_dto.dart';
import 'package:geolpo/login.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/widgets/global_widget.dart';
import 'package:intl/intl.dart';

class MyInfo extends StatefulWidget {
  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {

  MyInfoDto? myInfo;

  @override
  void initState() {
    super.initState();
    getMyInfo()
        .then((_) => myInfo = (_))
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
              child: Column(
                  children: [
                    getGlobalLine('내 정보', getMainFont()),
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
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text('닉네임', style: getMyInfoFont(),),
                                const Expanded(child: SizedBox()),
                                Text('${user?.name}', style: getMyInfoFont2())
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text('가입수단', style: getMyInfoFont(),),
                                const Expanded(child: SizedBox()),
                                myInfo?.socialType == 'KAKAO' ?
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: const Image(
                                    image: AssetImage('image/kakaotalk_sharing_btn_small.png'),
                                    width: 30.0,
                                  ),
                                ) :
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: const Image(
                                    image: AssetImage('image/naver_btnG.png'),
                                    width: 30.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text('가입일자', style: getMyInfoFont()),
                                const Expanded(child: SizedBox()),
                                Text(DateFormat('yyyy-MM-dd').format(user!.createdAt), style: getMyInfoFont2())
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text('구독팀 수', style: getMyInfoFont()),
                                const Expanded(child: SizedBox()),
                                Text('${myInfo?.subscribeTeamCount}', style: getMyInfoFont2())
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text('누적 알람 수', style: getMyInfoFont()),
                                const Expanded(child: SizedBox()),
                                Text('${myInfo?.totalAlertsCount}', style: getMyInfoFont2())
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: ElevatedButton(onPressed: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('알림', style: getAlertDialogTitleStyle(),),
                                  content: Text('탈퇴 후 3일간 재가입 불가하며\n저장된 구독 및 알림 정보는 모두 삭제됩니다.\n회원 탈퇴 하시겠습니까?', style: getAlertDialogContentStyle()),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                withDrawUser()
                                                    .then((_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login())));
                                              },
                                              child: Text('예', style: getButtonTextColor())),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('아니오', style: getButtonTextColor())),
                                        ),
                                      ]
                                    )
                                  ],
                                );
                              });
                              },
                              child: Text('회원 탈퇴', style: getButtonTextColor())
                            ),
                          )
                        ],
                      ),
                    ),
                  ]
              )
          ),
        )
    );
  }
}
