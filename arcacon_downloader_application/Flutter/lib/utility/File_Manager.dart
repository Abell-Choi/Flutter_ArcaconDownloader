import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;



class FileManager{
  final strGroupName;
  String? strRootPath;
  FileManager(String this.strGroupName);

  Future<String> getDeviceTemp() async{
    String documentsPath =  '/storage/emulated/0/Documents/';
    if (Platform.isIOS){
      Directory path = await getApplicationDocumentsDirectory();
      documentsPath = path.path +'/';
    }
    this.strRootPath = documentsPath;
    return documentsPath;
  }
  

  Future<List<dynamic>> saveArcaconData() async{
    return <dynamic>[];
  }

  Future<void> _saveImage() async{  //이미지 저장
    
  }
  Future<void> diotester() async{
    if (this.strRootPath == null){
      this.strRootPath = await this.getDeviceTemp();
    }

    String strUrl = 'https://ac-p2.namu.la/20220713sac/9869ea5841a6823beff4d74e1b56ff9e7a401bcc7c3b798d641bea3c30f7b86f.png';

    await GallerySaver.saveImage(
      strUrl,
      albumName: 'test',
      fileName: 'asdf.png'
    );
  }

  /*Future<void> dd() async{
    if (this.strRootPath == null){
      this.strRootPath = await this.getDeviceTemp();
    }
    String url = '';
    var req = await Dio().get(
      'https://ac2-p2.namu.la/20220706sac2/966771405a561887cf783de18c28c3ffc480b6dec3b4753feb5a595b9419aa19.png',
      options: Options(responseType: ResponseType.bytes)
    );
    final res = await ImageGallerySaver.saveImage(
      Uint8List.fromList(req.data),
      name: 'test2',
      album: 'asdf',
    );

    print(res);
  }*/

  Future<String> getOptionData() async{
    File file = await File(await this.getDeviceTemp() +'options.json');
    if ( await file.exists() == false ){
      this._optionDataRefrash();
    }

    file = await File(await this.getDeviceTemp() +'options.json');
    String readData = await file.readAsString();

    try{
      jsonDecode(readData);
    }catch(e){
      print('err -> $e');
      this._optionDataRefrash();
      return getOptionData();
    }
    return readData;
  }

  Future<void> _optionDataRefrash() async{
    File file = await File(await this.getDeviceTemp() +'options.json');
    Map<String, dynamic> option = {
      'url' : 'http://127.0.0.1',
      'port' : 8080
    };

    await file.writeAsString(jsonEncode(option));
  }

  Future<bool> setOptionData(Map<String, dynamic> optionData) async{
    File file = await File(await this.getDeviceTemp() +'options.json');
    await file.writeAsString(jsonEncode(optionData));
    return true;
  }

  Future<dynamic> _groupDocIsAlready() async{
    if (strGroupName == null){ await this.getDeviceTemp(); }
    if (await Directory(await getDeviceTemp() +strGroupName).exists() == false){
      return false;
    }return true;
  }

  Future<dynamic> _canCreateFile(String fileName) async{
    if (this.strRootPath == null){
      this.strRootPath = await this.getDeviceTemp();
    }
    bool d = await Directory(this.strRootPath!).exists();
    print('-> $d');
    if (await _groupDocIsAlready() == false){
      return false;
    }
    if (await File(this.strRootPath! +this.strGroupName +'/' +fileName).exists()){
      return false;
    }

    return true;
  }

  Future<bool> createGroupPath() async {
    bool res = await _groupDocIsAlready();
    if (res) { return false; }

    await Directory(strRootPath! +strGroupName).create();
    return true;
  }
  

  Future<bool> delGroupPath() async {
    bool res = await _groupDocIsAlready();
    if (!res) { return false; }
    await Directory(strRootPath! +strGroupName).delete();
    return true;
  }

  Future<dynamic> saveFile(File file, String fileName) async{

  }

}
