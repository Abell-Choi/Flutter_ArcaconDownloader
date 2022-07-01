
import 'package:flutter/material.dart';
import 'package:temp/Pages/Utility/card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  int _checkUrlData(String url){
    return 0;
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
                onPressed: (){
                  print(urlController.text);
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
