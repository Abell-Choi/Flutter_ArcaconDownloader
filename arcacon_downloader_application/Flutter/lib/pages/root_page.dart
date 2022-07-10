import 'dart:io';

import 'package:flutter/material.dart';
import 'dialog/dialog.dart';
import '../utility/Arcacon_Manager.dart';

class root_page extends StatefulWidget {
  const root_page({super.key});
  @override
  State<root_page> createState() => _root_pageState();
}

class _root_pageState extends State<root_page> {
  BoxDecoration bx = BoxDecoration(
    border: Border.all()
  );
  String lastWord = '';
  var __dec = BoxDecoration(
    border: Border.all(
      width: 2,
      color: Colors.blue,
    )
  );
  TextEditingController urlInputter = TextEditingController();
  List<Widget> listview_controller = [];

  @override
  void initState() {
    this.urlInputter.text = 'https://arca.live/e/';
    super.initState();
  }


  // 데이터 추가
  void addData() async{
    ArcaconManager arca = new ArcaconManager(this.urlInputter.text);
    var contentInformation = await arca.getContentInformation();
    if (contentInformation['res'] == 'err'){
      print(contentInformation);
      return;
    }

    String title = contentInformation['value']['title'];
    int code = contentInformation['value']['code'];
    List<String> contentUrlList = contentInformation['value']['contentUrlList'];
    DateTime insertTime = DateTime.now();
    String strDateTime = 
    '${insertTime.year}-${insertTime.month}-${insertTime.day} ${insertTime.hour}:${insertTime.minute}:${insertTime.second}';
    setState(() {
      Card card = Card(
        child: ListTile(
          leading: Image.network(contentUrlList[0]),
          title: Text(title),
          subtitle: Text('$strDateTime'),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert)
          ),
          isThreeLine: true,
        ),
      );

      this.listview_controller.insert(0, card);
    });
  }

  // 유틸 단
  void removeData(int? num){
    setState(() {
      if (listview_controller.length == 0){
        return;
      }
      num ??= this.listview_controller.length-1;

      listview_controller.removeAt(num!);
      return ;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double height_div = screen_height/5;

    // 디자인 단
    return Scaffold(
      body: Center(
        child: (
          Column(   // 2열 나누기
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: height_div *1,
              ),
              Container(  //윗집
                height: height_div*2,
                  child: Column(
                    children: [
                      Container(
                        height: height_div*0.5,
                      ),
                      Text(
                        'Arcacon Downloader',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width/2,
                        child: TextField(
                          controller: urlInputter,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'input url'
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (() => addData()),
                        child: Text('check data')
                        ),
                      ElevatedButton(
                        onPressed: ()=>removeData(null),                          
                        child: Text('flushed data')
                        )
                    ],
                  ),
                ),
              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                height: height_div*2,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: List.castFrom(listview_controller),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}