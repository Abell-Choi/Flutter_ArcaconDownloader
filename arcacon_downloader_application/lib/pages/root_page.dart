import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dialog/dialog.dart';
import '../utility/Arcacon_Manager.dart' as arca;

class root_page extends StatelessWidget {
  arca.ArcaconManager? arcaconManager = null;

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
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'url or arcacon code'
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(defualtPaddingSize),
              child: ElevatedButton(
                child: Text('ffff'),
                onPressed: (){
                  print(urlController.text);
                  arcaconManager = arca.ArcaconManager(urlController.text);
                  List<Widget> imgWidgets = [];
                  for ( String i in arcaconManager.getContentUrlList()['value'] ){
                    imgWidgets.add(Image.network(i));
                  }
                  dynamic ff = Custom_Dialog('ffff', getWidgetImages(), context);
                  showDialog(
                    context: context, 
                    builder: (context) => ff.gridView()
                  );  
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}