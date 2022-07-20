import 'package:application/Utility/FlaskManager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

//page
import './option_page.dart';

//custom
import '../Controller/controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AppController c = Get.put(AppController());
  Map<String, dynamic> _optionData = {};
  List<Widget> _downloadProgress = [];

  String _title = 'Arcacon Downloader';  
  String _downloadString = 'DOWNLOAD';
  String _optionString = 'OPTIONS';
  TextEditingController _urlController = TextEditingController();
  String _defaultUrl = 'https://arca.live/e/9146';

  FlaskManager? _flaskManager;


  Widget _defaultTextCustom(String txt){
    return Text(
      txt,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white
      )
    );
  }

  Widget getDownloadButton(String txt){
    return ElevatedButton(
      style: ButtonStyle(
      ),
      onPressed: (){_downloadFunc();},//this._downloadFunc(), 
      child: this._defaultTextCustom(txt)
    );
  }

  Widget getOptionbutton(String txt){
    return ElevatedButton(
      onPressed: () =>_optionFunc(), 
      child: this._defaultTextCustom(txt)
    );
  }

  _downloadFunc() async {
    Map<String, dynamic> res = await _flaskManager!.getArcaconInformation(strUrl: _urlController.text);
    if (res['res'] == 'err'){
      Get.showSnackbar(GetSnackBar(
        title: 'error',
        message: res['value'],
        duration: Duration(seconds: 3),
      ));
      return;
    }
    Get.showSnackbar(GetSnackBar(
      title: "${res['value']['title']}",
      message: '몬가 됨',
      duration: Duration(seconds: 3),
    ));
    return;
  }
  
  _optionFunc() async {
    var data = Get.to(OptionPage(), arguments: _optionData);
    return;
  }

  @override
  void initState() {
    print(c.resultData);
    this._optionData = c.optionData!;
    this._urlController.text = this._defaultUrl;
    _flaskManager = FlaskManager(
      this._optionData['url'],
      backendPort: this._optionData['port'],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max ,
        children: [
          Container(
            height: size.height *0.5,
            color: Colors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  this._title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  width: size.width*0.7,
                  child: TextField(
                    controller: _urlController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      focusColor: Colors.red
                    ),
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    this.getDownloadButton(this._downloadString),
                    this.getOptionbutton(this._optionString),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: List.from(this._downloadProgress),
            )
          ),
        ],
      ),
    );
  }
}