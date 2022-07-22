import 'package:flutter/material.dart';
import 'package:get/get.dart';

//custom
import '../Controller/controller.dart';
import '../Utility/FileManger.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  AppController c = Get.put(AppController());
  TextEditingController _urlController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  Map<String, dynamic> _arg = {};

  Card _customCard(IconData icon, String title, Widget content){
    Icon(Icons.data_array);
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: content,
      ),
    );
  }

  @override
  void initState() {
    this._urlController.text = c.optionData!['url'];
    this._portController.text = c.optionData!['port'].toString();
    this._arg = Get.arguments;
    super.initState();
  }

  @override
  void dispose(){
    if (int.tryParse(this._portController.text) == null){
      this._portController.text = c.optionData!['port'].toString();
    }

    if (int.parse(this._portController.text) > 65535 ||
    int.parse(this._portController.text) < 1){
      this._portController.text = c.optionData!['port'].toString();
    }

    this._arg['url'] = this._urlController.text;
    this._arg['port'] = int.parse(this._portController.text);
    print(this._arg);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: size.width *0.9,
          height: size.height *0.99,
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: ListView(
            children: [
              Container(
                child :Card(
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('options', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    tileColor: Colors.lightBlue,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(0,0,0,20),
              ),
              this._customCard(Icons.abc, 'asdf', TextField(
                controller: this._urlController,
              )),
              this._customCard(Icons.numbers, 'port', TextField(
                controller: this._portController,
              )),

              ElevatedButton(
                onPressed: ()=> Get.back(),
                child: Text('뒤로 가기')
              )
            ],
          ),
        ),
      ),
    );
  }
}