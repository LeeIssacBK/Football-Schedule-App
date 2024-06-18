

import 'package:flutter/material.dart';
import 'package:geolpo/api/mypage_api.dart';
import 'package:geolpo/dto/qna_dto.dart';
import 'package:geolpo/styles/text_styles.dart';
import 'package:geolpo/widgets/global_widget.dart';

class Qna extends StatefulWidget {
  @override
  State<Qna> createState() => _QnaState();
}

class _QnaState extends State<Qna> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                getGlobalLine('Q & A', getMainFont()),
                FutureBuilder<List<QnaDto>>(
                    future: getQnA(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(padding: EdgeInsets.all(30.0), child: CircularProgressIndicator());
                      }
                      List<QnaDto> qnaList = snapshot.data!;
                      return Column(
                        children: qnaList.map((qna) {
                            return ExpansionTile(
                              title: Text(qna.title, style: getDetailFont()),
                              subtitle: Text(qna.subtitle),
                              leading: const Icon(Icons.question_mark),
                              trailing: const Icon(Icons.arrow_drop_down),
                              backgroundColor: Colors.white,
                              textColor: Colors.indigo,
                              iconColor: Colors.indigo,
                              collapsedBackgroundColor: Colors.white,
                              collapsedTextColor: Colors.indigo,
                              collapsedIconColor: Colors.indigo,
                              children: [
                                ListTile(title: Text(qna.content))
                              ],
                            );
                          }).toList(),
                      );
                    },
                  )
              ]
            ),
          ),
        ),
      ),
    );
  }

}