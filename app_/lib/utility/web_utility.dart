import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

class WebParser{
  Dio dio = new Dio();
  String _backendURL = 'http://127.0.0.1:8080/';
  String _backend_Convert_path = this._backendURL +'convertmp4togif';
  String _rootUrl = 'https://arca.live/e/';
  String _page = 'p=';  // page index num
  String _rank = 'sort=rank';   // sorting rank or not
  String _target = 'target='; //finding target [title, nickname, tag]
  
  String _emoticon_className = '#emoticon';


  /**
   * int page = 페이지 번호
   * int sort = 0 등록순, 1 인기순
   * int target = 0 
   */
  Future <dynamic?> searchData({int page=1, int sort = 0, int target = 0, String keyword = ''}) async {
    
    List<String> params = [];
    params.add("?p=$page");
    sort==0?'':params.add("sort=rank");
    keyword!=''? 
      params.add("keyword=${keyword.split(' ').join('+')}&target=${['title','nickname','tag'][target]}")
    : '';
    var res = await this._searchData(this._rootUrl +params.join('&'));
    return res;
  }

  Future<dynamic> _backEndConvertGif(String gifSrc) async {
    var res = await dio.post(this._backend_Convert_path, data: {
      'url' : gifSrc
    });
    
  }

  
  Future<dynamic> _searchData(String url) {
    return dio.get(url).then((value) {
      var par = parser.parse(value.data);
      var doc = par.querySelector('.emoticon-list');
      if (doc == null) { return null; }

      List<Emoticon_Data> emo_datas = [];
      for (var i in doc.querySelectorAll('a')){
        if (i.parent!.className == 'sort') { continue; }
        dynamic imgData = i.querySelector('img');
        imgData??=i.querySelector('video');
        imgData = 'https:' +imgData!.attributes['src'];
        if (imgData.split(' ')[imgData.split(' ').length -1] == 'mp4'){
          print('mp4');
        }
        emo_datas.add(
          Emoticon_Data(
            i.querySelector('.title')!.text, 
            'https://arca.live'+i.attributes['href']!, 
            imgData,
            int.parse(i.querySelector('.count')!.text.split('번')[0]),
          )
        );
      }

      return emo_datas;

    },);
  }
}

class Emoticon_Data{
  String title = '';
  String emoticon_url = '';
  String title_emoticon_url = '';
  int count = 0;
  List<String> emoticon_urls = [];
  
  Emoticon_Data(String title, String emoticon_url, String title_emoticon_url, int count, {List<String>? lst = null}){
    this.title = title;
    this.emoticon_url = emoticon_url;

    if (title_emoticon_url.split('.')[1] == '.mp4'){
      print(title_emoticon_url);
      List<String> target = title_emoticon_url.split(' ');
      title_emoticon_url = '';
      for (String i in target){
        
      }
    }
    this.title_emoticon_url = title_emoticon_url;
    this.count = count;
    if (lst != null){ this.emoticon_urls = lst; }
    return;
  }

  String toString(){
    Map<String, dynamic> obj = {
      'title' : title,
      'emoticon_url' : emoticon_url,
      'title_emoticon_url' : title_emoticon_url,
      'count' : count,
      'emoticon_urls' : jsonEncode(emoticon_urls)
    };
    return jsonEncode(obj);
  }
}