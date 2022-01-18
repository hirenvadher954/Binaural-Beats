import 'package:binaural_beats/common/entities/entities.dart';
import 'package:binaural_beats/common/utils/utils.dart';

class UserAPI {
  static Future<UserLoginResponseEntity> login({
    UserLoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      '/user/login',
      data: params?.toJson(),
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  static Future<UserRegisterRequestEntity> register({
    UserRegisterRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      '/user/register',
      data: params?.toJson(),
    );
    return UserRegisterRequestEntity.fromJson(response);
  }

  static Future<UserLoginResponseEntity> profile() async {
    var response = await HttpUtil().post(
      '/user/profile',
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  static Future logout() async {
    return await HttpUtil().post(
      '/user/logout',
    );
  }
}
