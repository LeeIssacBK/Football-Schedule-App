import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolpo/api/auth_api.dart';
import 'package:geolpo/api/mypage_api.dart';
import 'package:geolpo/dto/myinfo_dto.dart';
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
                    getGlobalLine('내정보', getMainFont()),
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
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(onPressed: () {

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
