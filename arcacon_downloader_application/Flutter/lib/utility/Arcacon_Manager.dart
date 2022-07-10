
//import 'package:flutter/material.dart';//??
import 'dart:io';

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
    if (this.checkUrlData() != 1){
      print(this.checkUrlData());
      this.isValidData = checkUrlData();
    }
  }

  int checkUrlData(){
    this.conversion_Url_String = this.input_Url_String;
    return 1;
  }

  // 데이터가 존재하는지 여부 확인
  Future<String> checkPostUrl() async {
    this.isValidData = -666;
    dynamic httpData;
    try{
      httpData = await http.get(Uri.parse(this.conversion_Url_String));
    }catch(e){
      print('err1 -> ' +e.toString());
      this.isValidData = -1;
      return 'err';
    }
    this.httpDataDoc = parser.parse(httpData.body);
    String sel = 'div.article-body > *.emoticons-wrapper > *.emoticon';
    try{
      List<dynamic> selection = this.httpDataDoc!.querySelectorAll(sel);
      if (selection.length == 0){
        this.isValidData = 1;
        print(this.isValidData);
        return 'ok';
      }
    }catch(e){
      print(e.toString());
      this.isValidData = -2;
      return 'err';
    }
    this.isValidData = 1;
    return 'done';
  }

  Future<void> aliveChecker() async{
    if (this.isValidData == -666 || this.isValidData == -999){
      await checkPostUrl();
    }
  }

  Future<Map<String, dynamic>> getTitle() async {
    await aliveChecker();
    if (this.isValidData == -999){
      await checkPostUrl();
    }

    if (this.isValidData != 1){
      return this._resultType('err', this.isValidData);
    }
    //title parser .title-row > .title
    String title = this.httpDataDoc!.querySelectorAll('div.title-row > div.title')[0].text;
    return this._resultType('ok', title);

  }

  Future <Map<String, dynamic>> getContentUrlList() async{
    await aliveChecker();
    
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

  Future <Map<String, dynamic>> getArcaconCode() async{
    await aliveChecker();
    
    if (this.isValidData != 1){
      return this._resultType('err', 'some err');
    }

    if (this.conversion_Url_String.split('?') != -1){
      return this._resultType('ok', 4444);
    }

    return this._resultType('ok', this.conversion_Url_String.split('/')[this.conversion_Url_String.split('/').length-1]);
  }

  Future <Map<String, dynamic>> getContentInformation() async{
    await aliveChecker();

    if (this.isValidData != 1){
      return this._resultType('err', this.isValidData);
    }
    dynamic data = await getTitle();
    String title = data['value'];
    data = await getContentUrlList();
    List<String> dataUrlList = data['value'];
    data = await getArcaconCode();
    int arcaconCode = data['value'];

    return _resultType(
      'ok',
      <String, dynamic>{
        'title' : title,
        'contentUrlList' : dataUrlList,
        'code' : arcaconCode
      } 
    );
  }
}

//body > div.root-container > div.content-wrapper.clearfix > article > div > div.article-wrapper > div.article-body > div:nth-child(1)

//https://arca.live/e/23667?p=1