
import 'package:application/Pages/search_page.dart';
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
  bool _isDisposed = false;
  Map<String, dynamic> _optionData = {};
  List<Map<String, dynamic>> _downloadProgress = [];
  Map<String, dynamic> _downloadState = {};
  bool _isProcessing = false;

  Map<String, dynamic> _backendStates = {
    'res' : 'err',
    'value' : 'err'
  };

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

  _setBackendStates({isOneProc = false}) async {
    int _maxStack = isOneProc?-1:1;
    while(!this._isDisposed && !(_maxStack==0)){
    //print(_isProcessing);
      _maxStack ++;
      //print('conf');
      //print(_maxStack);
      await Future.delayed(Duration(milliseconds: this.c.optionData['refreshDelay']));
      if (_flaskManager == null){
        this._backendStates = {
          'res' : 'err',
          'value' : '_flask connection err'
        };
        continue;
      }
      _flaskManager!.setBackendOptions(c.optionData['url'], backendPort: c.optionData['port']);
      this._backendStates = await _flaskManager!.getBackendStates();
      setState(() { });
    }
    
    return true;
  }

  List<dynamic> _getBackendStatesIcon() {
    List<dynamic> res = <dynamic> [
      Icon(Icons.wifi),
      Icon(Icons.wifi_tethering),
      Color.fromARGB(0, 0, 0, 255)
    ];

    if (this._backendStates['res'] == 'err'){
      res =  <dynamic> [
        Icon(Icons.wifi_tethering_error),
        Icon(Icons.error),
        Color.fromRGBO(255, 93, 93, 1)
      ];
    }
    return res;
  }

  _downloadImage(String title, List<dynamic> targetUrl, dynamic conInfo) async {
    if (_downloadState.keys.toList().indexOf(title) != -1){
      if (!_downloadState[title]['break']){
        GetSnackBar(
          title: 'Error',
          message: '${title} 은 이미 다운중입니다',
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
        ).show();
        return;
      }
    }
    if (_downloadState.keys.toList().indexOf(title) == -1){

      var now = new DateTime.now();
      String formatDate = DateFormat('yy/MM/dd - HH:mm:ss').format(now);
      _downloadState[title] = {
        'index' : 0,
        'res' : <bool>[],
        'no' : 0,
        'max' : targetUrl.length,
        'info' : conInfo,
        'break' : false,
        'startAt' : formatDate,
      };

      _downloadProgress.add(_downloadState[title]);
    }
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
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _downloadState[title]['no'] ++;
        //print(_downloadState[title]['no']);
      });
    }

    _downloadState[title]['break'] = true;
    int _failed = 0;
    for (bool i in _downloadState[title]['res']){
      if (!i){ _failed ++; }
    }

    GetSnackBar(
      duration: Duration(seconds: 5),
      title: "$title 을 모두 다운로드 하였습니다.",
      message: "성공 : ${_downloadState[title]['max'] - _failed} \n실패 : ${_failed} \n전체 : ${_downloadState[title]['max']}",
    ).show();
    _downloadProgress.remove(_downloadState[title]);
    setState(() {});
  }

  Card _getListedCard(String title){
    double max = _downloadState[title]['max'].toDouble();
    double valNow = _downloadState[title]['no'].toDouble();
    double _value = valNow / max;
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
            Text("${_downloadState[title]['startAt']}"),
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
    return cd;
  }

  Widget _getDownloadButton(String txt){
    return ElevatedButton(
      onPressed: (){
        _downloadFunc();
        
        
      },//this._downloadFunc(), 
      child: this._defaultTextCustom(txt)
    );
  }

  Widget _getSearchButton(String txt){
    return ElevatedButton(
      onPressed: () async {
        var _searchPage = await Get.to(()=>Search_Page(), arguments: _optionData);
        if (_searchPage==null){
          return;
        }

        _downloadImage(
          _searchPage['title'],
          _searchPage['conList'],
          _searchPage
        );
      },
      child: this._defaultTextCustom(txt),
    );
  }

  Widget _getOptionButton(String txt){
    return ElevatedButton(
      onPressed: () =>_optionFunc(), 
      child: this._defaultTextCustom(txt)
    );
  }

  _downloadFunc() async { //download Function
    if (this._isProcessing == true){
          GetSnackBar(
            title: 'Error',
            message: '현재 다른 작업이 진행중 입니다.',
            duration: Duration(seconds:5),
          ).show();
          return;
    }
    this._isProcessing = true;
    if (this._backendStates['res'] == 'err'){
      GetSnackBar(
        title: '에러',
        message: '백앤드 서버가 연결되지 않았습니다.',
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      ).show();
      return;
    }
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

    Map<String, dynamic> _customArgs = Map.from(res['value']);
    _customArgs['title-img'] = await this._convertMp4ToGIF(_customArgs['title-img']);
    List<String> _conList = [];
    for( String i in _customArgs['conList']){
      _conList.add(await _convertMp4ToGIF(i));
    }
    _customArgs['conList'].clear();
    _customArgs['conList'].addAll(_conList);
    _customArgs['option'] = Map.from(this._optionData);


    for (String i in _customArgs['conList']){
      if (i.substring(i.length-3) == 'gif'){
        print(i);
      }
    }
    var data = await Get.dialog( Result_Dialog(), arguments: _customArgs );
    this._isProcessing = false;
    if (data == null) { return; }
    
    if (_downloadState[_customArgs['title']] != null){
      if (_downloadState[_customArgs['title']]['max'] == 
          _downloadState[_customArgs['title']]['no']){
          
          _downloadState.removeWhere((key, value) => key == _customArgs['title']);
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
    await Get.to(()=>OptionPage(), arguments: _optionData);
    await c.setOptionData(this._optionData);
    //print(this._optionData);
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
    //print(c.resultData);
    this._optionData = Map.from(c.optionData);
    this._urlController.text = this._defaultUrl;
    _flaskManager = FlaskManager(
      this._optionData['url'],
      backendPort: this._optionData['port'],
    );
    
    this._setBackendStates();
    //_addCustomCard('test');
  }

  @override
  void dispose() {
    this._isDisposed = true;
    super.dispose();
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
            width: size.width,
            height: size.height *0.5,
            color: Colors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  this._title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                ),
                Container(  //url inputter
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
                Container(  // backend States
                  alignment: Alignment.center,
                  width: size.width *.7,
                  child: Card(
                    color: _getBackendStatesIcon()[2],
                    child: ListTile(
                      onLongPress: () async {
                        await Get.to(OptionPage(), arguments: _optionData);
                        //c.setOptionData(_optionData);
                      },
                      onTap: () => _setBackendStates(isOneProc: true),

                      leading: this._getBackendStatesIcon()[0],
                      title: Text('Backend Status', textAlign: TextAlign.center,),
                      trailing: this._getBackendStatesIcon()[1],
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    this._getDownloadButton('다운로드'),
                    this._getSearchButton('검색'),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: this._downloadProgress.length,
              itemBuilder: ((context, index) {
                return _getListedCard(_downloadProgress[index]['info']['title']);
            })),
          ),
        ],
      ),
    );
  }
}