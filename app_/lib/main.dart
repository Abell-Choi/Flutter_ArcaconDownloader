import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './utility/GetController.dart';

import './pages/00.root_page.dart';
void main() {
  runApp(const GetMaterialApp(home: RootPage()));
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AppController _c = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Obx(() { 
          if (_c.isConnectedData.value) {
            return MainPage();
          } else {
            return Center(child: CircularProgressIndicator());		// 초기화중. Splash 화면
          }
        }
    );
  }
}
