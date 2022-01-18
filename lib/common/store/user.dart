import 'dart:convert';

import 'package:binaural_beats/common/apis/apis.dart';
import 'package:binaural_beats/common/entities/entities.dart';
import 'package:binaural_beats/common/services/services.dart';
import 'package:binaural_beats/common/values/values.dart';
import 'package:get/get.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  final _isLogin = false.obs;
  final _profile = UserLoginResponseEntity().obs;
  String token = '';

  bool get isLogin => _isLogin.value;

  UserLoginResponseEntity get profile => _profile.value;

  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    String profileOffline =
        StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      _profile(UserLoginResponseEntity.fromJson(jsonDecode(profileOffline)));
    }
  }

  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  Future<void> getProfile() async {
    if (token.isEmpty) return;
    var result = await UserAPI.profile();
  }

  Future<void> onLogout() async {
    if (_isLogin.value) await UserAPI.logout();
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    _isLogin.value = false;
    token = '';
  }
}
