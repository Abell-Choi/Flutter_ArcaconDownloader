import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
//pages
import './Pages/main_page.dart';

//custom module
import './Controller/controller.dart';
void main() async{
  runApp(
    GetMaterialApp(
      title: 'Getx example',
      home: Splash(),
    )
  );
}

class Splash extends StatelessWidget {
  final AppController c = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Obx(() { 
        if (c.isInitialized.value){
          if (c.resultData['res'] == 'ok'){
            return MainPage();
          }else if (c.resultData['res'] == 'err'){
            return Scaffold(
              body: Center(child: Text('err')),
            );
          }else{
            return Center(child: Text('asdf'),);
          }
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    );
  }
}