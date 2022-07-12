import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileManager{
  final strGroupName;
  String? strRootPath;
  FileManager(String this.strGroupName);

  Future<String> getDeviceTemp() async{
    String documentsPath = '/storage/emulated/0/Documents/';
    if (Platform.isIOS){
      Directory path = await getApplicationDocumentsDirectory();
      documentsPath = path.path +'/';
    }
    this.strRootPath = documentsPath;
    return documentsPath;
  }

  Future<String> getOptionData() async{
    File file = await File(await this.getDeviceTemp() +'options.json');
    if ( await file.exists() == false ){
      // make new json options
      print('make new file');
      Map<String, String> option = {
        'url' : 'http://127.0.0.1:8080',
      };

      String strJsonData = jsonEncode(option);
      await file.writeAsString(strJsonData);
    }

    file = await File(await this.getDeviceTemp() +'options.json');
    String readData = await file.readAsString(); 
    return readData;
  }

  Future<bool> setOptionData(Map<String, String> optionData) async{
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
