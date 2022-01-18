import 'package:binaural_beats/common/services/services.dart';
import 'package:binaural_beats/common/values/values.dart';
import 'package:get/get.dart';

class ConfigStore extends GetxController {
  static ConfigStore get to => Get.find();

  bool isFirstOpen = false;

  @override
  void onInit() {
    super.onInit();
    isFirstOpen = StorageService.to.getBool(STORAGE_DEVICE_FIRST_OPEN_KEY);
  }

  Future<bool> saveAlreadyOpen() {
    return StorageService.to.setBool(STORAGE_DEVICE_FIRST_OPEN_KEY, false);
  }
}
