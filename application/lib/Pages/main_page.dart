import 'package:application/Utility/FileManger.dart';
import 'package:application/Utility/FlaskManager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

//page
import './option_page.dart';
import './dialog_result.dart';

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
  Map<String, dynamic> _downloadState = {};

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

  _downloadImage(String title, List<dynamic> targetUrl, dynamic conInfo) async {
    if (_downloadState.keys.toList().indexOf(title) == -1){
      _downloadState[title] = {
        'res' : <bool>[],
        'no' : 0,
        'max' : targetUrl.length,
        'info' : conInfo,
        'break' : false,
      };
    }

    _addCustomCard(title);
    for (String i in targetUrl){
      if (_downloadState[title]['break']){
        return;
      }
      _downloadState[title]['res'].add(
        await FileManager().downloadArcacon(
          i, 
          title
        )
      );
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _downloadState[title]['no'] ++;
        print(_downloadState[title]['no']);
      });
    }
  }

  _addCustomCard(title){
    double max = _downloadState[title]['max'].toDouble();
    double valNow = _downloadState[title]['no'].toDouble();
    double _value = valNow / max;
    var now = new DateTime.now();
    String formatDate = DateFormat('yy/MM/dd - HH:mm:ss').format(now);
    Card cd = Card(
      child: ListTile(
        leading: Image.network(_downloadState[title]['info']['title-img']),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 24
          ),  
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$formatDate"),
            Text("${_downloadState[title]['no'].toString()} / ${_downloadState[title]['max'].toString()}")
            //Text('a'),
            //Text('b')
          ],
        ),
        trailing: Container(
          height: 100,
          margin: EdgeInsets.all(10),
          child: CircularProgressIndicator(
            value: _value,
          ),
        ),
      ),
    );

    setState(() {
      this._downloadProgress.add(cd);    
    });
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

  _downloadFunc() async { //download Function
    Map<String, dynamic> res = await _flaskManager!.getArcaconInformation(strUrl: _urlController.text);
    if (res['res'] == 'err'){
      Get.showSnackbar(GetSnackBar(
        title: 'error',
        message: res['value'],
        duration: Duration(seconds: 3),
      ));
      return;
    }

    // custom args
    print(res['value'].keys);

    Map<String, dynamic> _customArgs = Map.from(res['value']);
    _customArgs['title-img'] = await this._convertMp4ToGIF(_customArgs['title-img']);
    List<String> _conList = [];
    for( String i in _customArgs['conList']){
      _conList.add(await _convertMp4ToGIF(i));
    }
    _customArgs['conList'].clear();
    _customArgs['conList'].addAll(_conList);
    _customArgs['option'] = Map.from(this._optionData);

    var data = await Get.dialog( Result_Dialog(), arguments: _customArgs );
    if (data == null) { return; }
    
    if (_downloadState[_customArgs['title']] != null){
      if (_downloadState[_customArgs['title']]['max'] == 
          _downloadState[_customArgs['title']]['no']){
          
          _downloadState.removeWhere((key, value) => key == _customArgs['title']);
      }else{
        GetSnackBar(
          title: 'Error',
          message: '${_customArgs['title']} 은 이미 다운중입니다',
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
        ).show();
        return;
      }
    }

    GetSnackBar(
      title: '${_customArgs['title']}',
      message: "다운로드 목록이 추가되었습니다.",
      duration: Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
    ).show();


    _downloadImage(
      _customArgs['title'], 
      _customArgs['conList'], 
      _customArgs
    );
    //print (data);
    return;
  }
  
  _optionFunc() async {
    print(_optionData);
    await Get.to(()=>OptionPage(), arguments: _optionData);
    await c.setOptionData(this._optionData);
    print(this._optionData);
    return;
  }

  Future<String> _convertMp4ToGIF( String targetUrl ) async{
    int _strLength = targetUrl.length;
    if (targetUrl.substring(_strLength-3) == 'mp4'){
      Map<String, dynamic> res = await _flaskManager!.convertMP4ToGIF(targetUrl);
      return "${_optionData['url']}:${_optionData['port'].toString()}${res['value']}";
    }
    
    return targetUrl;
  }

  @override
  void initState() {
    print(c.resultData);
    this._optionData = Map.from(c.optionData!);
    this._urlController.text = this._defaultUrl;
    _flaskManager = FlaskManager(
      this._optionData['url'],
      backendPort: this._optionData['port'],
    );
    //_addCustomCard('test');
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
                    ElevatedButton(onPressed: (){
                      this._addCustomCard('asdfasdfsa');
                    }, child: Text('ddd'))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: this._downloadProgress,
            )
          ),
        ],
      ),
    );
  }
}