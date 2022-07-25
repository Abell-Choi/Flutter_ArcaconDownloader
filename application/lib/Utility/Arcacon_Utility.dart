import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'dart:convert';

import '../Utility/FlaskManager.dart';

class Arcacon{
  String _arcacon_url = 'https://arca.live/e/';
  String _unknownImgUrl = 'https://media.moddb.com/images/downloads/1/103/102311/background.png';

  Map<String, dynamic> getSearchArcaconData(
    String title,
    int count,
    String maker,
    String href,
    String titleImg
  ){
    return {
      'title' : title,
      'count' : count,
      'maker' : maker,
      'href' : href,
      'title-img' : titleImg
    };
  }

  Future<Map<String, dynamic>> searchContent(
    String keyword,
    FlaskManager _flaskManager, 
    {
      bool rank=false,
      int target=0,
      int page=1,
    }
  ) async {
    //target => 0 : title, nickname, tag
    //rank = 등록순 판매순
    List<String> lstTarget = [
      'title',
      'nickname',
      'tag'
    ];

    String url = '${this._arcacon_url}?';
    url+='keyword=${keyword}';
    url+='&target=${lstTarget[target]}';
    url+=rank?'&sort=rank':'';
    url+='&p=${page.toString()}';
    var res = await this.__getConnectResult(url);

    print(res);
    if (res['res'] == 'err'){return res;}

    //target class tag = .emoticon-list

    var selector = parser.parse(res['value'].body).querySelector('.emoticon-list');
    if (selector == null) { return {'res' : 'err', 'value' : 'query is null!'};}
    List<Map<String,dynamic>> emoticon_data = [];
    List<dynamic> temp = [];
    dynamic imgTemp;
    for (var i in selector.querySelectorAll('.emoticon-list > a')){
      temp.clear();
      print(i.querySelector('div > div > .title')!.text);
      print(i.querySelector('div > div > .maker')!.text);
      temp.add(i.querySelector('div > div > .title')!.text);
      temp.add(int.tryParse(i.querySelector('div > div > .count')!.text.split('번')[0])!);
      temp.add(i.querySelector('div > div > .maker')!.text);
      temp.add(i.attributes['href']);
      imgTemp = 'https:';
      try{
        imgTemp += i.querySelector('div > img')!.attributes['src'];
      }catch(e){
        imgTemp += i.querySelector('div > video')!.attributes['src'];
      }

      if (imgTemp.substring(imgTemp.length-3) == 'mp4'){
        var fls = await _flaskManager.convertMP4ToGIF(imgTemp);
        if (fls['res'] == 'err'){
          print("img convert err -> ${fls}");
          imgTemp = _unknownImgUrl;
        }else{
          imgTemp = "${_flaskManager.getFullBackendUrl()}${fls['value']}";
        }
      }
      temp.add(imgTemp);
      emoticon_data.add(
        this.getSearchArcaconData(
          temp[0], 
          temp[1], 
          temp[2], 
          temp[3],
          '${temp[4]}'
        )
      );
    }

    return {'res' : 'ok', 'value' : emoticon_data};
  }


  Future <Map<String, dynamic>> __getConnectResult(
    String url, 
    {
      Map<String, dynamic>? body, 
      bool post=false
    }
  ) async {
    body ??= {};
    http.Response postData;
  
    if (post){
      try{
        postData = await http.post(
          Uri.parse(url),
          body: body
        );
      }catch(e){
        return {'res' : 'err', 'value' : '$e'};
      }
    }

    try{
      postData = await http.get(
        Uri.parse(url)
      );
    }catch(e){
      return <String, dynamic> {'res' : 'err', 'value' : '$e'};
    }

    return {'res' : 'ok', 'value' : postData};
  }
}