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


  ListTile lstile(Image img, String title, String subTitle) => ListTile(
    leading: img,
    title: Text(title),
    subtitle: Text(subTitle),
    trailing: Icon(Icons.more_vert),
    isThreeLine: true,
  );

  List<Widget> listview_controller = [];


  @override
  void initState() {
    this.urlInputter.text = 'https://arca.live/e/';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double height_div = screen_height/5;

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
                        onPressed: (){
                          setState(() {
                            listview_controller.add(
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.abc),
                                  title: Text('asdf'),
                                  subtitle: Text('asdfff'),
                                ),
                              )
                            );
                          });
                        }, 
                        child: Text('check data')
                        ),
                      ElevatedButton(
                        onPressed: (){
                          this.listview_controller.clear();
                        }, 
                        child: Text('flushed data')
                        )
                    ],
                  ),
                ),
              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                decoration: bx,
                height: height_div*2,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: List.from(listview_controller),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}