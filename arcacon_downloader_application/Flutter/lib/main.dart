import 'dart:convert';

import 'package:arcacon_downloader_application/pages/main_page.dart';
import 'package:flutter/material.dart';
import './utility/File_Manager.dart';

import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(
        name: '/', 
        page: ()=> Splash()
      ),
    ],
  ));
}

class Splash extends StatelessWidget {
  //const Splash({super.key});

  Map<String, dynamic> options = {'url' : 'http://127.0.0.1'};

  Future<dynamic> getInitData() async {
    var Options = FileManager('');
    return jsonDecode(await Options.getOptionData());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('click next'),
              ElevatedButton(
                onPressed: () async {
                  this.options = await this.getInitData();
                  Get.off(() => HomePage(), arguments: this.options);
              }, 
              child: Text('move next'))
            ],
          ),
        ),
      ),
    );
  }
}