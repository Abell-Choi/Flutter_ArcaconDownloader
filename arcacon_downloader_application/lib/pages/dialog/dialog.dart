import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Custom_Dialog{
  String? title;
  List<Widget>? image_lists;
  BuildContext? context;

  Custom_Dialog(String title, List<Widget> image_lists, BuildContext context){
    this.title = title!;
    this.image_lists = image_lists!;
    this.context = context!;
  }

  Widget gridSetting(){
    return new Container(
      width: MediaQuery.of(context!).size.width * .7,
      height: MediaQuery.of(context!).size.width * .7,
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: image_lists!,
      ),
    );
  }
  
  Widget gridView(){
    return AlertDialog(
      title: Text(
        this.title!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          gridSetting(),
        ]
      ),
      actions: [
        Text('Custom_Dialog')
      ],
    );
  }
}