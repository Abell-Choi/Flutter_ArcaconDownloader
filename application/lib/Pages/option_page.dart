import 'package:flutter/material.dart';
import 'package:get/get.dart';

//custom
import '../Controller/controller.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  AppController c = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.black,
        ),
      ),
    );
  }
}