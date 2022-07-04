import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class root_page extends StatelessWidget {
  

  TextEditingController urlController = TextEditingController();
  double defualtPaddingSize = 8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(defualtPaddingSize),
              child: Text(
                'Arcacon Downloader',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),  
              ),
            ),
            Container(
              padding: EdgeInsets.all(defualtPaddingSize),
              width: MediaQuery.of(context).size.width/3*2,
              child: TextField(
                controller: urlController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(defualtPaddingSize),
              child: ElevatedButton(
                child: Text('asdf'),
                onPressed: (){
                  print(urlController.text);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}