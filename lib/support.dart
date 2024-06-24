

import 'package:flutter/material.dart';
import 'package:geolpo/api/mypage_api.dart';
import 'package:geolpo/dto/support_dto.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/widgets/global_widget.dart';

class Support extends StatefulWidget {

  @override
  State<Support> createState() => _SupportState();

}

class _SupportState extends State<Support> {

  final List<String> types = ['이용방법', '오류', '의견', '기타'];
  String? selectedType;
  String? title;
  String? content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                getGlobalLine('문의하기', getMainFont()),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(children: [Text('유형', style: getDetailFont2())],),
                      DropdownButton(
                          isExpanded: true,
                          hint: const Text('문의 유형 선택', style: TextStyle(color: Colors.indigo, fontSize: 18)),
                          style: const TextStyle(color: Colors.indigo),
                          underline: Container(
                            height: 1,
                            color: Colors.indigo,
                          ),
                          value: selectedType,
                          items: types.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedType = newValue;
                            });
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(children: [Text('제목', style: getDetailFont2())],),
                      TextField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo), // Border color when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal), // Border color when focused
                          ),
                        ),
                        onChanged: (text) {
                          title = text;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(children: [Text('내용', style: getDetailFont2(),)],),
                      SizedBox(
                        height: 300.0,
                        child: TextField(
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo), // Border color when not focused
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal), // Border color when focused
                            ),
                          ),
                          onChanged: (text) {
                            content = text;
                          },
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: null,
                          expands: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (selectedType == null || title == null || content == null) {
                          showDialog(context: context, builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('알림', style: getAlertDialogTitleStyle(),),
                              content: Text('문의 내용을 모두 기입해주세요.', style: getAlertDialogContentStyle()),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('확인', style: getButtonTextColor(),)),
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                        } else {
                          showDialog(context: context, builder: (
                              BuildContext context) {
                            return AlertDialog(
                              title: Text('알림', style: getAlertDialogTitleStyle(),),
                              content: Text('문의 하시겠습니까?\n문의 내용 확인 후 가입시 등록된 이메일로 답변됩니다.',
                                  style: getAlertDialogContentStyle()),
                              actions: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              submitSupport(SupportDto(type: selectedType!, title: title!, content: content!))
                                                  .then((_) => {
                                                    if ((_)) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('문의를 제출하였습니다.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                                                            backgroundColor: Colors.teal,
                                                            duration: Duration(milliseconds: 3000),))
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('문제가 발생하였습니다. 잠시후 다시 시도해주세요.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                                                            backgroundColor: Colors.redAccent,
                                                            duration: Duration(milliseconds: 3000),))
                                                  }
                                              }).then((_) => Navigator.of(context).pop())
                                                  .then((_) => Navigator.of(context).pop());
                                            },
                                            child: Text('예',
                                              style: getButtonTextColor(),)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('아니오',
                                              style: getButtonTextColor(),)),
                                      ),
                                    ]
                                ),
                              ],
                            );
                          });
                        }
                      },
                      child: Text('문의하기', style: getButtonTextColor(),)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}