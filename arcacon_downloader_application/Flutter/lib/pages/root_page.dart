import 'package:flutter/material.dart';
import 'dialog/dialog.dart';
import '../utility/Arcacon_Manager.dart' as arca;

class root_page extends StatefulWidget {
  const root_page({super.key});
  @override
  State<root_page> createState() => _root_pageState();
}

class _root_pageState extends State<root_page> {
  String lastWord = '';
  var __dec = BoxDecoration(
    border: Border.all(
      width: 2,
      color: Colors.blue,
    )
  );

  int __stackCount = 0;
  TextEditingController urlInputter = TextEditingController();

  double maxHeight = 0.0;
  double choppedHeight = 0.0;
  double maxWidth = 0.0;

  Container listContainer(
    Widget img,
    String title,
    int maxDataNum,
    Widget progrationBar
  ) => Container(
    margin: EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.blue,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    height: choppedHeight *3 /4,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: maxWidth / 4,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          child: img,
          height: double.infinity,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: choppedHeight *3 /4 /4 *3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //width: double.infinity,
                    child: Text(
                      title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),
                    ),
                  ),
                  Container(
                    //width: double.infinity,
                    child: Text(
                      title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              child: progrationBar,
            )
          ],
        )
      ],
    ), 
  );
  List<Container> listview_controller = [];
  @override
  void initState() {
    this.urlInputter.text = 'https://arca.live/e/';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.maxHeight = MediaQuery.of(context).size.height;
    this.choppedHeight = this.maxHeight/7;
    this.maxWidth = MediaQuery.of(context).size.width;

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
                      '몰?루',
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
                        onChanged: ((value) {
                          if (value == lastWord){
                            return;
                          }
                          if (value == null){
                            return;
                          }
                          if (value.length -2 == lastWord.length){
                            print(1);
                            lastWord = value;
                          }
                          else if (value.length-2 < lastWord.length){
                            lastWord = value;
                          }
                          print('$value // ${this.lastWord}');
                        }),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        super.setState(() {
                          __stackCount ++;
                          this.listview_controller.insert(
                            0,
                            listContainer(
                              Icon(Icons.dangerous, size: 72, color: Colors.blue,), 
                              'title', 
                              999, 
                              Text('here is new Progration bar')
                            )
                          );
                          if (this.listview_controller.length > 10){
                            this.listview_controller.removeLast();
                          }
                        });
                      }, 
                      child: Text('check Data')
                    ),
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          this.__stackCount = 0;
                          this.listview_controller.clear();
                        });
                      }, child: Text('test Flushed')
                    ),
                  ],
                ),
              )
            ),
            Container(
              height: this.choppedHeight * 3,
              margin: EdgeInsets.all(0),
              child: ListView(
                padding: EdgeInsets.all(0),
                children: List.from(this.listview_controller),
              ),
            )
          ],
        ),
      )
    );
  }
}