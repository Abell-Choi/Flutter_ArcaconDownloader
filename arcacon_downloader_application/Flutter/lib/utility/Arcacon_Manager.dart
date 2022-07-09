
//import 'package:flutter/material.dart';//??
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

class ArcaconManager{
  final input_Url_String;
  int isValidData = -999;
  String conversion_Url_String = '';
  Map<String, String> arcaconData = {};
  Document? httpDataDoc;

  Map<int, String> errorTable = {
    -999 : 'not Starting work',
    -1 : 'not support String type',
    -2 : 'can\'t find arcacon data',
    -3 : 'connection err',
    -404 : '404 error',
  };

  ArcaconManager(String this.input_Url_String){
    conversion_Url_String = this.input_Url_String;
    if (checkUrlData() < 0){
      this.isValidData = checkUrlData();
    }
    checkPostUrl();
  }

  int checkUrlData(){
    String target_Url_String = this.conversion_Url_String;
    //digit test
    if (int.tryParse(target_Url_String) != null){
      this.conversion_Url_String = 'https://arca.live/e/${this.conversion_Url_String}';
      return 1;
    }

    if (this.conversion_Url_String.indexOf('http://') == -1 &&
        this.conversion_Url_String.indexOf('https:/') == -1){
          if (this.conversion_Url_String.indexOf('arca.live/e/') == -1){
            return -1;
          }
          this.conversion_Url_String = 'https://${this.conversion_Url_String}';
          return -1;
        }
    return -1;

  }

  // 데이터가 존재하는지 여부 확인
  void checkPostUrl() async {
    dynamic httpData;
    try{
      httpData = await http.get(Uri.parse(this.conversion_Url_String));
    }catch(e){
      print(e.toString());
      this.isValidData = -1;
      return;
    }

    this.httpDataDoc = parser.parse(httpData.body);
    getContentUrlList();
    String sel = 'div.article-body > *.emoticons-wrapper > *.emoticon';
    try{
      List<dynamic> selection = this.httpDataDoc!.querySelectorAll(sel);
      if (selection.length == 0){
        this.isValidData = 1;
        return;
      }
    }catch(e){
      print(e.toString());
      this.isValidData = -2;
      return;
    }

  }

  Map<String, dynamic> getTitle(){
    if (this.isValidData != 1){
      return this._resultType('err', this.isValidData);
    }
    //title parser .title-row > .title
    String title = this.httpDataDoc!.querySelectorAll('div.title-row > div.title')[0].text;
    return this._resultType('ok', title);

  }

  Map<String, dynamic> getContentUrlList(){
    if (this.isValidData != 1){
      return this._resultType('err', this.isValidData);
    }

    //ListParser
    List<String> dataSet = [];
    for (Element i in this.httpDataDoc!.querySelectorAll('div.emoticons-wrapper > *.emoticon')){
      dataSet.add('https:' +i.attributes['src'].toString());
    }
    
    Map<String, String> d = {};
    return this._resultType('ok', dataSet);
  }

  Map<String, dynamic> _resultType(String res, dynamic value){
    Map<String, dynamic> resTemp = {};
    resTemp['res'] = res;
    resTemp['value'] = value;
    resTemp['type'] = resTemp['value'].runtimeType;

    return resTemp;
  }
}

//body > div.root-container > div.content-wrapper.clearfix > article > div > div.article-wrapper > div.article-body > div:nth-child(1)

//https://arca.live/e/23667?p=1