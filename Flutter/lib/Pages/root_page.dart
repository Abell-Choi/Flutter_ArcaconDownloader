
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:temp/Pages/Utility/card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> fetchPost() {
  return http.get(Uri.parse('www.naver.com'));
}

runApplication() => {
      runApp(MaterialApp(
        home: RootPage(),
      ))
    };

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  TextEditingController urlController = TextEditingController();

  Container constructedContainer(Widget child) => Container(
    margin: EdgeInsets.all(8),
    child: Center( child: child ),
    width: MediaQuery.of(context).size.width/3*2,
  );

  Future<String> getParse(String url, String strData) async{
    var getData = await http.post(
      Uri.parse(url),
      headers: <String, String> { 'Content-Type': 'application/x-www-form-urlencoded',},
      body: <String, String> { 'strData' : strData }
    );
    return getData.body;
  }

//실패시
void errorDialog() {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              new Text("에러"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "해당 데이터를 찾을 수 없습니다.",
              ),
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
  }

  // 작업 성공시 다일로그
  void resDialog(String title, String targetData) async {
    var getRes = await getParse(
      'http://127.0.0.1:8080/api/v1/getArcaconContents', 
      targetData
    );

    Map<String, dynamic> data = jsonDecode(getRes);

    print(data['value'][0]);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(
                data['value'][0] 
              ),
            ]
          ),
          actions: <Widget>[
            TextButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            constructedContainer(Text('아카콘 다운로더')),
            constructedContainer(
              TextField(
                controller: urlController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "url",
                ),
              )
            ),
            constructedContainer(
              ElevatedButton(
                onPressed: ()async{
                  Map<String, dynamic> jsonData = jsonDecode (await getParse(
                    'http://127.0.0.1:8080/api/v1/findArcaconContents', 
                    urlController.text
                    ));

                  // 임시 에러처리
                  if (jsonData['res'] == 'err'){ 
                    print('err');
                    errorDialog();
                    return;
                  }

                  resDialog(jsonData['value'], urlController.text);
                }, 
                child: Text('Search')
              )
            ),
          ],
        ),
      ),
    );
  }
}
