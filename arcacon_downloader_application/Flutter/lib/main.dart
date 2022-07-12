import 'package:arcacon_downloader_application/pages/option_page.dart';
import 'package:flutter/material.dart';
import 'pages/root_page.dart';
import 'pages/download_page.dart';
import 'utility/Arcacon_Manager.dart' as arca;

import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(
        name: '/', 
        page: ()=> Splash()
      ),
      GetPage(
        name: '/root',
        page: () => root_page()
      ),
    ],
  ));
}

class Splash extends StatelessWidget {
  const Splash({super.key});

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
                onPressed: (){
                  Get.to(root_page());
              }, 
              child: Text('move next'))
            ],
          ),
        ),
      ),
    );
  }
}