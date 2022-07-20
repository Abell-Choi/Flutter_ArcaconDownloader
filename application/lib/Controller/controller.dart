import 'package:get/get.dart';

// Cuscom utility
import '../Utility/FileManger.dart';

class AppController extends GetxService {
  static AppController get to => Get.find();

  final isInitialized = false.obs;
  Map<String, dynamic>? optionData = {
    'url' : 'err',
    'port' : 0000
  }.obs;


  Map<String, dynamic> resultData = {
    'res' : 'no',
    'value' : ''
  }.obs;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }
  
  @override
  void onClose() {
    isInitialized.value = false;
    super.onClose();
  }
  
  // 초기화 루틴
  Future<void> initialize() async {

    Map<String, dynamic> _optionData = await FileManager().getOptionData();

    if (_optionData!['res'] == 'err'){
      resultData = _optionData.obs;
      return;
    }

    optionData = _optionData['value'];
    await Future.delayed(Duration(seconds: 3));
    resultData['res'] = 'ok';
    isInitialized.value = true;
    return;
  }
}