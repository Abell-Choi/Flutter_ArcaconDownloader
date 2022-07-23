import 'dart:convert';
import 'dart:io';


import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; 

// custom module
import './FlaskManager.dart';

class FileManager{
  String _optionFileName = 'option.json';
  String? _appPath;
  Map<String, dynamic> _defaultOptionData = {
    'url' : 'http://127.0.0.1',
    'port' : 8080,
    'refreshDelay' : 2000,
  };

  Future<void> _updateAppPath() async{
    if (this._appPath != null){ return; }
    String docPath = '/storage/emulated/0/Documents/';
    if (Platform.isIOS){
      await Future.delayed(Duration(seconds: 3));
      Directory path = await getApplicationDocumentsDirectory();
      docPath = path.path +'/';
    }
    this._appPath = docPath;
  }

  Future<Map<String, dynamic>> getOptionData() async {
    await _updateAppPath();

    File _optionFile = await File(
      "${this._appPath}${this._optionFileName}"
    );

    // 데이터 존재시
    if (! await _optionFile.exists() ){
      await this.setOptionData(this._defaultOptionData);
      return <String, dynamic> {
        'res' : 'ok',
        'value' : this._defaultOptionData
      };
    }

    // decode 실패
    try{
      Map<String, dynamic> optionData = jsonDecode(await _optionFile.readAsString());

      return <String, dynamic> {
        'res' : 'ok',
        'value' : optionData
      };
    }catch(e){
      print('json decode err -> ${e}');
      print('restored option file');
      await this.setOptionData(this._defaultOptionData);
      return <String, dynamic>{
        'res' : 'err',
        'value' : 'json decode err -> ${e}'
      };
    }
  }

  Future<Map<String, dynamic>> setOptionData(Map<String, dynamic> data) async {
    await _updateAppPath();
    File _optionFile = await File(
      "${this._appPath}${this._optionFileName}"
    );

    try{
      await _optionFile.writeAsString(jsonEncode(data));
      return <String,dynamic> {
        'res' : 'ok',
        'value' : 'data saving'
      };
    }catch(e){
      return <String, dynamic> {
        'res' : 'err',
        'value' : 'some error with saving -> ${e}',
      };
    }
  }

  Future<Map<String, dynamic>> addDownloadLog (String conName) async {
    await _updateAppPath();
    File _targetFile = await File(
      "${this._appPath}${conName}.json"
    );

    if (await _targetFile.exists()){
      return {
        'res' : 'err',
        'value' : 'already exists data'
      };
    }
    var now = new DateTime.now();
    String formatDate = DateFormat('yy/MM/dd - HH:mm:ss').format(now);
    
    try{
      await _targetFile.create();
      await _targetFile.writeAsString(
        jsonEncode({
          'inputDate' : formatDate
        })
      );
    }catch(e){
      return {'res' : 'err', 'value' : 'some err -> $e'};
    }

    return {
      'res' : 'ok',
      'value' : '$conName.json is created'
    };
  }

  Future<Map<String, dynamic>> delDownloadLog (String conName) async {
    await _updateAppPath();
    File _targetFile = await File(
      "${this._appPath}${conName}.json"
    );

    if (!await _targetFile.exists()){
      return {
        'res' : 'err',
        'value' : '$conName is not exists'
      };
    }

    try{
      await _targetFile.delete();
    }catch(e){
      return {
        'res' : 'err',
        'value' : 'some err in proc -> $e'
      };
    }
    return {
      'res' : 'ok',
      'value' : '$conName.json is deleted'
    };
  }
  

  Future<bool> downloadArcacon(String url, String group) async {
    bool? res = await GallerySaver.saveImage(
      url,
      albumName: group,
    );

    return res!;
  }
}