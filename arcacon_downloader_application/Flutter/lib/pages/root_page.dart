import 'package:flutter/material.dart';
import 'dialog/dialog.dart';
import '../utility/Arcacon_Manager.dart' as arca;

class root_page extends StatefulWidget {
  const root_page({super.key});
  @override
  State<root_page> createState() => _root_pageState();
}

class _root_pageState extends State<root_page> {
  TextEditingController urlInputter = TextEditingController();

  double maxHeight = 0.0;
  double choppedHeight = 0.0;

  @override
  void initState() {
    this.urlInputter.text = 'https://arca.live/e/';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.maxHeight = MediaQuery.of(context).size.height;
    this.choppedHeight = this.maxHeight/7;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: choppedHeight * 4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: choppedHeight*2,
                    ),
                    Text(
                      'Arcacon Downloader',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width /5 *3,
                      child: TextField(
                        controller: urlInputter,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){}, 
                      child: Text('check Data')
                    )
                  ],
                ),
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black
                )
              ),
              height: this.choppedHeight * 3,
              margin: EdgeInsets.all(0),
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  Container(
                    color: Colors.red,
                    height: this.choppedHeight * 3 / 4,
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}