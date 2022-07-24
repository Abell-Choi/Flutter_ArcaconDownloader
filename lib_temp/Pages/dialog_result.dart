import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utility/FileManger.dart';

class Result_Dialog extends StatefulWidget {
  const Result_Dialog({super.key});

  @override
  State<Result_Dialog> createState() => _Result_DialogState();
}

class _Result_DialogState extends State<Result_Dialog> {
  String _backString = '뒤로가기';
  String _downloadString = '다운받기';
  Map<String, dynamic> _arg = {};
  Map<String, dynamic> _customArgs = {};
  List<Container> _castData = [];
  @override
  void initState() {
    this._arg = Get.arguments;
    super.initState();
  }

  List<Container> _getImageWidgets() {
    List<Image> lst = [];
    for (String i in _arg['conList']) {
      _castData.add(Container(
        margin: EdgeInsets.all(4),
        child: Image.network(
          i,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            );
          },
        ),
      ));
    }
    return _castData;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(body: Container(
      width: size.width ,
      height: size.height * .9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              '${_arg["title"]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            height: size.height * .1,
          ),
          Container(
            //color: Colors.blue,
            height: size.height * .2,
            child: Image.network(
              "${_arg['title-img']}",
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
              return child;
            }
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            );
              },
            ),
          ),
          Expanded(
              child: GridView.count(
            padding: EdgeInsets.all(9),
            crossAxisCount: 4,
            children: this._getImageWidgets(),
          )),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () async {
                  var existsCheck = await FileManager().addDownloadLog(_arg['title']);
                  if (existsCheck['res'] == 'err'){
                    var res = await Get.dialog(_alreadyExistCheck());
                    if (res == null || res == false){
                      Get.back(result: null);
                    }
                  }
                  Get.back(result: true);
                } ,
                child: Text('$_downloadString')
              ),
              ElevatedButton(
                onPressed: ()=> Get.back(result: null),
                child: Text("$_backString"),
              )
            ],
          ),
        ],
      ),
    ));
  }
}


class _alreadyExistCheck extends StatelessWidget {
  const _alreadyExistCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('경고'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error),
          Text('해당 데이터는 이미 다운받은 데이터입니다.\n그래도 다운로드 하시겠습니까?')
        ],
      ),
      actions: [
        TextButton(onPressed: (){
          Get.back(result: true);
        }, child: Text("확인")),
        TextButton(onPressed: (){
          Get.back(result: false);
        }, child: Text('취소'))
      ],
    );
  }
}