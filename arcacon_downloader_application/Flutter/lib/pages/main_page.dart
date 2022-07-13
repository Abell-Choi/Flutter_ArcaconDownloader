import 'package:arcacon_downloader_application/utility/File_Manager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import './option_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Arcacon Downloader';
  TextEditingController urlController = TextEditingController();
  List<Widget> _downloadList_Controller = [];
  Map<String,dynamic> _options = Get.arguments;

  void _set_options (Map<String, dynamic>? mapData) {
    mapData ??= Get.arguments;

    this._options = mapData!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Container(  //upper container
            height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/10,
                ),
                Container(  // title
                  child: Text(
                    '$title',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                Container(  // text Input
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width/2,
                  child: TextField(
                    controller: urlController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'input url...'
                    ),
                  ),
                ),
                Container(
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton( //Download Try
                        onPressed: (){
                          print(_options);
                        }, 
                        child: Text('Download')
                      ),
                      ElevatedButton( //go _options
                        onPressed: () async {
                          Get.to(()=>Option_Page(), arguments: _options);
                          FileManager('').setOptionData(_options);
                        }, 
                        child: Text('_options')
                      ),
                    ],
                  ),
                ),  // buttons
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(2),
              children: List.from(_downloadList_Controller),
            )
          ),
        ],
      ),
    );
  }
}