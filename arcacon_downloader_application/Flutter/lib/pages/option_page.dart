import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';

class Option_Page extends StatefulWidget {
  const Option_Page({super.key});

  @override
  State<Option_Page> createState() => _Option_Page_State();
}

class _Option_Page_State extends State<Option_Page> {
  TextEditingController targetUrl = TextEditingController();


  Map<String, String> option = {
    'url' : 'http://127.0.0.1:8080',
  };

  @override
  void initState(){
    this.targetUrl.text = option['url']!;
    super.initState();
  }

  @override
  void dispose(){
    print('end of dispose -> ' +this.targetUrl.text);
    option['url'] = this.targetUrl.text;
    super.dispose();
  }

  Card _defaultCard(Widget title, Widget? subTitle, Widget? icon,) => Card(
    child : ListTile(
      leading: icon,
      title: title ??= Container(child: null,),
      subtitle: subTitle,
    )
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Colors.blue,
              alignment: Alignment.center,
              //margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              height: MediaQuery.of(context).size.height/10,
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.help, size: 32,),
                  title: Text(
                    'Options',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.red,
              width: MediaQuery.of(context).size.width,
              //height: double.infinity- MediaQuery.of(context).size.height/10,
              height: MediaQuery.of(context).size.height*8/10,
              child: ListView(
                padding: EdgeInsets.all(2),
                children: [
                  _defaultCard(
                    TextField(
                      controller: targetUrl,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                      ),
                      onSubmitted: (value){
                        print(value);
                      },
                    ), 
                    null,
                    Icon(Icons.read_more),
                  ),
                  Card(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(result: option);
                        print('end of back button');
                      },
                      child: Text('뒤로가기'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}