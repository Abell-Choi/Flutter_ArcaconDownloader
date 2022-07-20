import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(
        name: '/', 
        page: ()=> Splash_Page()
      ),
    ],
  ));
}

class Splash_Page extends StatefulWidget {
  const Splash_Page({super.key});

  @override
  State<Splash_Page> createState() => _Splash_PageState();
}

class _Splash_PageState extends State<Splash_Page> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}