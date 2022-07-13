import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:get/get.dart';
class Option_Page extends StatefulWidget {
  const Option_Page({super.key});

  @override
  State<Option_Page> createState() => _Option_PageState();
}

class _Option_PageState extends State<Option_Page> {
  TextEditingController urlController = TextEditingController();
  var options = Get.arguments;
  @override
  void initState() {
    this.urlController.text = options['url'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/10,
                color: Colors.blue,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(24),
                child: Text(
                  'Options',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),  
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.web),
                  title: Text('input backend URL'),
                  subtitle: TextField(
                    controller: urlController,
                    onChanged: (value) {
                      this.options['url'] = this.urlController.text;
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/3,
                child: ElevatedButton(
                  child: Text('go back'),
                  onPressed: (){
                    options['url'] = urlController.text;
                    Get.back();
                  },
                ),
              )
            ],
          )
        )
    );
  }
}