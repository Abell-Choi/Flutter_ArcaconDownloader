import 'package:arcacon_downloader_application/utility/File_Manager.dart';
import '../utility/Flask_Manager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import './option_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Arcacon Downloader';
  TextEditingController urlController = TextEditingController();
  List<Widget> _downloadList_Controller = [];
  Map<String, dynamic> _options = Get.arguments;

  void _set_options(Map<String, dynamic>? mapData) {
    mapData ??= Get.arguments;

    this._options = mapData!;
  }

  void _showInformationDialog(String targetUrl, {BuildContext? ctx}) async {
    print('_showInformationDialog -> $targetUrl');
    FlaskManager fm = new FlaskManager(this._options['url'],
        backendPort: int.parse(this._options['port']), targetUrl: targetUrl);

    var res = await fm.getArcaconInformation();
    if (res['res'] == 'err') {
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: '$targetUrl is not arcacon url',
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      ));
      return;
    }
    this._showConfirmDialog(res['value'], ctx: ctx!);
  }

  void _showConfirmDialog(Map<String, dynamic> value,
      {BuildContext? ctx}) async {
    List<Widget> img = [];
    String titleImage = value['title-img'];
    if (titleImage.substring(titleImage.length -3) == 'mp4'){
      titleImage = "${this._options['url']}:${this._options['port']}" +
            (await FlaskManager(this._options['url'])
                .convertMP4ToGIF(titleImage))['value'];
    }

    String imgTemp = '';
    for (int i = 0; i < value['conList'].length; i++) {
      imgTemp = value['conList'][i];
      if (imgTemp.substring(imgTemp.length - 3) == 'mp4') {
        imgTemp = "${this._options['url']}:${this._options['port']}" +
            (await FlaskManager(this._options['url'])
                .convertMP4ToGIF(imgTemp))['value'];
      }
      img.add(Card(child: Image.network(imgTemp)));
    } //https://arca.live/e/23834?p=1
    await Get.dialog(Scaffold(
        body: Center(
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(ctx!).size.height * .9,
        width: MediaQuery.of(ctx).size.width * .8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                '${value["title"]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.red,
              child: Image.network(titleImage),
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(ctx).size.height * .6,
              width: MediaQuery.of(ctx).size.width * .85,
              child: GridView.count(
                crossAxisCount: 4,
                children: img,
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){}, 
                  child: Text('download')
                ),
                ElevatedButton(
                  onPressed: (){Get.back();}, 
                  child: Text('close')
                )
              ],
            )
          ],
        ),
      ),
    )));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            //upper container
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Container(
                  // title
                  child: Text(
                    '$title',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Container(
                  // text Input
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    controller: urlController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'input url...'),
                  ),
                ),
                Container(
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          //Download Try
                          onPressed: () async {
                            this._showInformationDialog(this.urlController.text,
                                ctx: context);
                          },
                          child: Text('Download')),
                      ElevatedButton(
                          //go _options
                          onPressed: () async {
                            await Get.to(() => Option_Page(),
                                arguments: _options);
                            FileManager('').setOptionData(_options);
                          },
                          child: Text('_options')),
                    ],
                  ),
                ), // buttons
              ],
            ),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(2),
            children: List.from(_downloadList_Controller),
          )),
        ],
      ),
    );
  }
}
