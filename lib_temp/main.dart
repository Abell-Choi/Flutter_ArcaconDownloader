import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';
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

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  final AppController c = Get.put(AppController());

  getPermission() async{
    var status = await Permission.contacts.status;
    if(status.isGranted){
      print('허락됨');
    } else if (status.isDenied){
      print('거절됨');
      Permission.contacts.request(); // 허락해달라고 팝업띄우는 코드
      Permission.mediaLibrary.request();
      Permission.storage.request();
    }
  }
  
  @override
  initState(){
    super.initState();
    getPermission();
  }


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
