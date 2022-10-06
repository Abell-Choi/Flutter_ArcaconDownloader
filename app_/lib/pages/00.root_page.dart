import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/GetController.dart';
import '../utility/web_utility.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

//making default page
class _MainPageState extends State<MainPage> {
  AppController _c = Get.put(AppController());
  ScrollController _scrollController = new ScrollController();
  List<Emoticon_Data> _emoList = [];
  int _now = 1;
  int _sort = 0;
  bool _refreshing = false;

  Size size = Size(0, 0);
  bool _isRankData = false;

  @override
  void initState() {
    super.initState();
    updateEmoData(1, 0);
    _scrollController.addListener(() async {
      if (_refreshing){ return; }

      if (_scrollController.position.maxScrollExtent <= _scrollController.offset && !_refreshing){
        _refreshing = true;
        this._now ++;

        print('updated -> ${this._refreshing} \nload... -> ${this._now}');
        updateEmoData(_now, this._sort);
      }
      return;
    },);
  }

  void updateEmoData(int page, int sort,
      {String keyword = '', int target = 0}) {
    WebParser().searchData(page: page, sort: sort).then((((value) {
      _emoList.addAll(value);
      setState(() {this._refreshing = false;});
    })));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: GridView.builder(
                  //Default Grid View
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 5 / 6, //가로 세로 비율 (세로가 1임)
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  controller: _scrollController,
                  itemCount: _emoList.length,
                  itemBuilder: ((context, index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue[100],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(50),
                                  child: _emoList[index].title_emoticon_url.split('.')[1] != '.mp4'?
                                  Image.network(
                                    _emoList[index].title_emoticon_url,
                                    scale: .5,
                                  )
                                  :Container(child: null),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  _emoList[index].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                          )
                        ],
                      )
                    );
                  })),
            ),
          ),
          Container(
            height: size.height * .1,
            color: Colors.blue[100],
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  width: size.width * .7,
                  height: size.height * .07,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(25))),
                  child: TextField(),
                ),
                SizedBox(
                  width: size.width * .03,
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  alignment: Alignment.center,
                  height: size.height * .07,
                  width: size.height * .07,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(25))),
                  child: TextButton(
                      onPressed: () async {
                        _c.webParser.searchData(sort: 1, keyword: 'test');
                      },
                      child: Icon(Icons.settings)),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
