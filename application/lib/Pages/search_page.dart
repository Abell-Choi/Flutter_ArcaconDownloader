import 'package:application/Utility/FlaskManager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utility/Arcacon_Utility.dart';
import '../Pages/dialog_result.dart';

class Search_Page extends StatefulWidget {
  const Search_Page({super.key});

  @override
  State<Search_Page> createState() => _Search_PageState();
}

class _Search_PageState extends State<Search_Page> {
  List<int> _searchOption = [0,0];
  final _scrollController = ScrollController();
  double _maxScrollPosition = 0;
  FlaskManager _flaskManager = new FlaskManager(
    Get.arguments['url'],
    backendPort: Get.arguments['port'],
  );

  Arcacon ac = Arcacon();
  TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _listResultData = [];
  String _lastSearchData = '';
  int _lastSearchPage = 0;
  bool _isRunning = false;

  String _searchString = 'search';
  String _searchOptionString = 'upload';

  Card _getListedCard(int nNum) {
    Map<String, dynamic> _castMap = Map.from(_listResultData[nNum]);
    Card card = Card(
      child: ListTile(
          onTap: () => _downloadFunc(_castMap),
          leading: Image.network(
            _castMap['title-img'],
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              );
            },
          ),
          title: Text(_castMap['title']),
          subtitle: Row(
            children: [
              Icon(Icons.download),
              Text("\t${_castMap['count'].toString()} \t"),
              Text(_castMap['maker'])
            ],
          )),
    );
    return card;
  }

  _getContentData() async {
    _isRunning = true;
    _lastSearchPage++;
    if (this._lastSearchData != this._textEditingController.text) {
      _listResultData.clear();
      _lastSearchPage = 0;
    }
    this._lastSearchData = this._textEditingController.text;

    var tt = await ac.searchContent(
        '${this._textEditingController.text}',
        _flaskManager,
        page: _lastSearchPage,
        rank: this._searchOption[0]==0?false:true,
        target: this._textEditingController.text!=''?this._searchOption[1]:0
        );
    if (tt['res'] == 'err') {
      this._lastSearchPage--;
      setState(() {});
      _isRunning = false;
      return;
    }

    this._listResultData.addAll(tt['value']);
    setState(() {});
    _isRunning = false;
  }

  _downloadFunc(Map<String, dynamic> _castMap) async {
    var _mapRes = await this
        ._flaskManager
        .getArcaconInformation(strUrl: "https://arca.live${_castMap['href']}");

    if (_mapRes['res'] == 'err') {
      GetSnackBar(
        title: 'Error',
        message: '해당 데이터를 가져오기에 실패하였습니다.\n${_mapRes['value']}',
        duration: Duration(seconds: 5),
      );
      return;
    }

    Map<String, dynamic> _customArgs = Map.from(_mapRes['value']);
    _customArgs['title-img'] = _castMap['title-img'];
    List<String> _conList = [];
    for (String i in _customArgs['conList']) {
      if (i.substring(i.length - 3) == 'mp4') {
        var _convertRes = await _flaskManager.convertMP4ToGIF(i);
        if (_convertRes['res'] == 'err') {
          GetSnackBar(
            title: 'Err',
            message: '${_convertRes['value']}',
            duration: Duration(seconds: 5),
          );
          return;
        }
        i = "${_flaskManager.getFullBackendUrl()}${_convertRes['value']}";
      }

      _conList.add(i);
    }
    _customArgs['conList'].clear();
    _customArgs['conList'].addAll(_conList);
    _customArgs['option'] = Map.from(Get.arguments);

    var res = await Get.dialog(Result_Dialog(), arguments: _customArgs);
    if (res == true) {
      Get.back(result: _customArgs);
    }
    return false;
  }

  @override
  void initState() {
    runInit();
    _scrollController.addListener(() async {
      if (this._isRunning == true) {
        print('blocked');
        return;
      }
      if (this._isRunning == false) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          this._isRunning = true;
          print('refreshData -> ${_lastSearchPage.toString()}');
          await _getContentData();
        }
      }
      //print("offset -> ${_scrollController.offset}");
      //print('max -> ${_scrollController.position.maxScrollExtent}');
    });
    super.initState();
  }

  runInit() async {
    _lastSearchPage++;
    var tt = await ac.searchContent(
        '${this._textEditingController.text}', _flaskManager);
    if (tt['res'] == 'err') {
      return;
    }

    _listResultData.addAll(tt['value']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            // 위
            height: size.height * .35,
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(''),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 36,
                    ),
                    Text(
                      "$_searchString",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: Colors.white),
                    ),
                    Expanded(
                      child: Text(''),
                    ),
                    IconButton(
                        onPressed: () async {
                          var res = await Get.dialog(_OptionDialog(), arguments: this._searchOption);
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextField(
                    controller: this._textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: () {
                      _listResultData.clear();
                      _lastSearchPage = 0; 
                      setState(() {
                        _getContentData();
                      });
                    },
                    child: Text(
                      "  $_searchString",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(size),
                        alignment: Alignment.bottomLeft,
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 0, 90, 163))),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            //아래
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8),
              itemCount: this._listResultData.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    child: ListTile(
                      title: Text("result data"),
                    ),
                  );
                }
                return this._getListedCard(index - 1);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _OptionDialog extends StatefulWidget {
  const _OptionDialog({super.key});

  @override
  State<_OptionDialog> createState() => __OptionDialogState();
}

class __OptionDialogState extends State<_OptionDialog> {
  
  int _sorting = Get.arguments[0];
  int _type = Get.arguments[1];
  List<int> _optionSearch = Get.arguments;

  var lstCol = [MaterialStateProperty.all(Colors.red),MaterialStateProperty.all(Colors.blue)];
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _optionSearch[0] = _sorting;
    _optionSearch[1] = _type;
    //Get.arguments[0] = _sorting;
    //Get.arguments[1] = _type;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
        title: Text('OPTIONS'),
        content: Container(
          height: size.height * .4,
          width: size.width *2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
            Card(
              child: ListTile(
                title: Text('정렬 방법'), 
                subtitle: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: (){
                            _sorting = 0;
                            setState(() {});
                          },
                          child: Text('등록순'),
                          style: ButtonStyle(
                            backgroundColor: 
                              this._sorting==0?lstCol[1]:lstCol[0]
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: (){
                            _sorting = 1;
                            setState(() {});
                          },
                          child: Text('인기순'),
                          style: ButtonStyle(
                            backgroundColor: 
                              this._sorting==1?lstCol[1]:lstCol[0]
                          ),
                        ),
                      )
                    ],
                  ),
                )
              )
            ),
            Card(
              margin: EdgeInsets.all(0),
              child: ListTile(
                title: Text('검색 조건'), 
                subtitle: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: (){
                            _type = 0;
                            setState(() {});
                          },
                          child: Text('제목'),
                          style: ButtonStyle(
                            backgroundColor: 
                              this._type==0?lstCol[1]:lstCol[0]
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: (){
                            _type = 1;
                            setState(() {});
                          },
                          child: Text('제작자'),
                          style: ButtonStyle(
                            backgroundColor: 
                              this._type==1?lstCol[1]:lstCol[0]
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: (){
                            _type = 2;
                            setState(() {});
                          },
                          child: Text('태그'),
                          style: ButtonStyle(
                            backgroundColor: 
                              this._type==2?lstCol[1]:lstCol[0]
                          ),
                        ),
                      )
                    ],
                  ),
                )
              )
            ),
          ]),
        ));
  }
}