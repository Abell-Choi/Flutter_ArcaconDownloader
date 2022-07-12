import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';


class BackEndManager{
  final targetUrl;
  String strKey = 'abcd';

  Document? httpDataDoc = null;
  bool _isvalidData = false;
  BackEndManager(String this.targetUrl){
    checkPostUrl();
  }

  // 데이터가 존재하는지 여부 확인
  Future<void> checkPostUrl() async {
    dynamic httpData;
    
    try{
      httpData = await http.post(
        Uri.parse(this.targetUrl),
        headers: <String, String> 
        {'Content-Type': 'application/x-www-form-urlencoded',},
        body: <String, String> {'strKey' : this.strKey},
      );
    }catch(e){
      return;
    }
    this.httpDataDoc = parser.parse(httpData.body);
    Map<String, dynamic> resMap;
    try{
      resMap = jsonDecode(this.httpDataDoc!.querySelector('body')!.text);
    }catch(e){
      print('err -> $e');
      return;
    }
    if (resMap['res'] == 'ok' && resMap['value'] == this.strKey){
      print(resMap);
      _isvalidData = true;
      return;
    }
    print(resMap);
    return;
  }

  Future <Map<String, dynamic>> __getConnectResult( String url, Map<String, dynamic> body ) async{
    Response postData;
    try{
      postData = await http.post(
        Uri.parse(url),
        body: body
      );
    }catch(e){
      return <String, dynamic> {'res' : 'err', 'value' : '$e'};
    }
    Map<String, dynamic> resData;
    try{
      resData = jsonDecode(parser.parse(postData.body).querySelector('body')!.text);
    }catch(e){
      return <String, dynamic> {'res' : 'err', 'value' : '$e'};
    }
    return resData;
  }

  Future<Map<String, dynamic>> getContentInformation( String url ) async {
    return await this.__getConnectResult(
        this.targetUrl +'/getArcaconInformation', 
        {'strTargetLink' : url}
    );
  }

  Future<Map<String, dynamic>> mp4ToGIF( String url ) async{
    Map<String, dynamic> res = await this.__getConnectResult(
      this.targetUrl +'/convertMP4ToGIF', 
      {'strTargetLink' : url}
    );
    res['value'] = '${this.targetUrl}' +res['value'];
    return res;
  }
  bool isValidData(){ return httpDataDoc==null?this._isvalidData?true:false:false; }
}