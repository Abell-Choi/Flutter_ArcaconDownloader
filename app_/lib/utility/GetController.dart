import 'package:get/get.dart';
import './web_utility.dart';

class AppController extends GetxService{
  var isConnectedData = false.obs;
  WebParser webParser = new WebParser();
  
  @override
  void onInit(){
    initialize();
    super.onInit();
  }

  Future<void> initialize() async{
    print("adsf");
    await Future.delayed(Duration(seconds: 1));
    print("ok");
    this.isConnectedData.value = true;
    return;
  }
}