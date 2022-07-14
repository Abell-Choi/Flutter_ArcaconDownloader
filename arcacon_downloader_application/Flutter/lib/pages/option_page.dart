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
  TextEditingController portController = TextEditingController();
  var options = Get.arguments;

  Card _optionCard(
    String optionKey,
    Icon icon,
    String title,
    TextEditingController textField_Controller,
    {ElevatedButton? btn}
  ){
    return Card(
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        subtitle: TextField(
          controller: textField_Controller,
          textAlign: TextAlign.start,
          onChanged: (value) {
            this.options[optionKey] = value;
          },
        ),
        trailing: btn,
      ),
    );
  }
  @override
  void initState() {
    this.urlController.text = options['url'];
    this.portController.text = options['port'].toString();
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
              this._optionCard(
                'url',
                Icon(Icons.rounded_corner), 
                'Backend URL', 
                urlController
              ),
              this._optionCard(
                'port',
                Icon(Icons.portrait_rounded),
                'PORT Num',
                portController
              ),
              Container(
                width: MediaQuery.of(context).size.width/3,
                child: ElevatedButton(
                  child: Text('go back'),
                  onPressed: (){
                    options['url'] = urlController.text;
                    options['port'] = portController.text;
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