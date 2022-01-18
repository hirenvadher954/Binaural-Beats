import 'package:binaural_beats/common/store/store.dart';
import 'package:binaural_beats/common/values/values.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;

import 'loading.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: SERVER_API_URL,
      connectTimeout: 10000,
      receiveTimeout: 5000,
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        return handler.next(response); // continue
      },
      onError: (DioError e, handler) {
        Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e); //continue
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        return handler.next(response); // continue
      },
      onError: (DioError e, handler) {
        Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e); //continue
      },
    ));
  }
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }


  Future get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool refresh = false,
        bool noCache = !CACHE_ENABLE,
        bool list = false,
        String cacheKey = '',
        bool cacheDisk = false,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future postForm(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future postStream(
      String path, {
        dynamic data,
        int dataLength = 0,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}


void onError(ErrorEntity eInfo) {
  if (kDebugMode) {
    print('error.code -> ' +
      eInfo.code.toString() +
      ', error.message -> ' +
      eInfo.message);
  }
  switch (eInfo.code) {
    case 401:
      UserStore.to.onLogout();
      EasyLoading.showError(eInfo.message);
      break;
    default:
      EasyLoading.showError('Unknown');
      break;
  }
}
ErrorEntity createErrorEntity(DioError error) {
  switch (error.type) {
    case DioErrorType.cancel:
      return ErrorEntity(code: -1, message: "Request cancellation");
    case DioErrorType.connectTimeout:
      return ErrorEntity(code: -1, message: "Connection timed out");
    case DioErrorType.sendTimeout:
      return ErrorEntity(code: -1, message: "Request timed out");
    case DioErrorType.receiveTimeout:
      return ErrorEntity(code: -1, message: "Response timed out");
    case DioErrorType.response:
      {
        try {
          int errCode =
              error.response != null ? error.response!.statusCode! : -1;

          switch (errCode) {
            case 400:
              return ErrorEntity(code: errCode, message: "Syntax error");
            case 401:
              return ErrorEntity(code: errCode, message: "Permission denied");
            case 403:
              return ErrorEntity(
                  code: errCode, message: "Server refuses to execute");
            case 404:
              return ErrorEntity(
                  code: errCode, message: "Can not reach server");
            case 405:
              return ErrorEntity(
                  code: errCode, message: "Request method is forbidden");
            case 500:
              return ErrorEntity(
                  code: errCode, message: "Internal server error");
            case 502:
              return ErrorEntity(code: errCode, message: "Invalid request");
            case 503:
              return ErrorEntity(code: errCode, message: "Service Unavailable");
            case 505:
              return ErrorEntity(code: errCode, message: "Gateway Timeout");
            default:
              {
                return ErrorEntity(
                  code: errCode,
                  message: error.response != null
                      ? error.response!.statusMessage!
                      : "",
                );
              }
          }
        } on Exception catch (_) {
          return ErrorEntity(code: -1, message: "Unknown");
        }
      }
    default:
      {
        return ErrorEntity(code: -1, message: error.message);
      }
  }
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";

  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}


