import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';

import 'dart:io';
import 'dart:convert';

class FlaskManager{
  String backendUrl;
  int? backendPort;
  String? targetUrl;

  Map<String, dynamic> backendTable = {
    'getArcaconInformation' : 'strTargetLink',
    'convertMP4ToGIF' : 'strTargetLink',
  };

  FlaskManager( String this.backendUrl, {int? backendPort, String? targetUrl} ){
    this.backendPort ??= 8080;
    this.backendUrl = _urlConstructor(backendUrl)!;
    this.targetUrl = targetUrl;
    print(this.backendUrl);
    
  }

  String? _urlConstructor( String url ){
    if (url.indexOf('http://') == -1 && url.indexOf('https://') == -1){
      url = 'http://' +url;
    }

    if (url.substring(url.length-1) == '/'){
      url = url.substring(0, url.length-1);
    }
    url += ':${this.backendPort}/';
    return url;
  }

  Future <Map<String, dynamic>> __getConnectResult( String url, Map<String, dynamic> body ) async{
    Response postData;
    try{
      postData = await http.post(
        Uri.parse(url),
        body: body,
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

  Map<String, dynamic> _error ( String value ){
    return <String, dynamic> {
      'res' : 'err',
      'value' : '$value'
    };
  }

  Future< dynamic > getArcaconInformation({String? strUrl}) async {
    strUrl ??= this.targetUrl;
    if (strUrl == null || strUrl!.indexOf(' ') != -1) {
      print('err -> $strUrl');
      return this._error('check your strUrl');
    };
    return this.__getConnectResult(
      this.backendUrl +'/getArcaconInformation',
      <String, dynamic>{
        this.backendTable['getArcaconInformation'] : strUrl
      }
    );
  }
}