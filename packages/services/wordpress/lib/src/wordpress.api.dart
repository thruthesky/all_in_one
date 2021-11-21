import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.api.dart';
import '../defines.dart';

/// 가능한 모든 에러는 하나의 service 함수에서 에러 메시지를 분석해서 UI 로 표시한다.
/// 그래야, 통일된 에러 관련 코드를 작성 할 수 있다. 예를 들어 Google Analytics 나 에러 통계를
/// 내려고 할 때, 쉽게 작업 할 수 있다.
class WordpressApi {
  final dio = Dio();

  /// [url] 은 [init] 함수에서 초기화 되어야 한다.
  String url = '';
  String get sessionId => UserApi.instance.currentUser.sessionId;

  /// [hookServerError] 에 콜백 함수가 지정되면,
  /// 서버(백엔드) 자체에서 발생하는 에러를 throw 하기 전에, 먼저 이 콜백 함수로 에러를 전달하여 호출한다.
  /// 클라이언트 앱에서는 이 에러를 받아서, Firebase Crashlytics 등에 기록하는 등의 추가적인 작업을 할 수 있다.
  /// 이 훅 함수에서, UI 에 표시되는 작업을 하지 않도록 한다.
  // Function? hookServerError;

  // @Deprecated('Use CurrencyApi.instance')
  // CurrencyApi currency = CurrencyApi();

  // Api Singleton
  static WordpressApi? _instance;
  // Api instance 를 리턴
  // ```dart
  // print('user: ${UserApi.instance.runtimeType}');
  // print('user: ${UserApi.instance.runtimeType}');
  // print('user: ${UserApi.instance.runtimeType}');
  // ```
  static WordpressApi get instance {
    if (_instance == null) {
      _instance = WordpressApi();
    }
    return _instance!;
  }

  /// 로그인을 하면 [onLogin] 콜백이 호출된다.
  Function? onLogin;

  /// 회원 가입을 하면, [onRegister] 콜백이 호출된다.
  Function? onRegister;

  /// ERROR_IGNORE 가 발생 할 때, 마지막 에러 메시지.
  // String ignoredServerErrorMessage = '';

  init({
    required String url,
    // Function? hookServerError,
    Function? onLogin,
    Function? onRegister,
  }) {
    this.url = url;
    this.onLogin = onLogin;
    this.onRegister = onRegister;
    // this.hookServerError = hookServerError;
  }

  /// [cacheKey] 가 주어졌으면, 그냥 [cacheKey] 만 사용한다.
  /// [cacheKey] 가 주어지지 않았으면, [data] 값을 바탕으로 캐시 키 값을 만든다.
  getCacheKey(MapStringDynamic data, String? cacheKey) {
    if (cacheKey != null) {
      return cacheKey;
    }

    List<String> primary = [];
    for (final k in data.keys) {
      if (k == 'session_id') continue;
      if (data[k] is String || data[k] is int) primary.add('$k=${data[k]}');
    }
    cacheKey = primary.join('&');
    return cacheKey;
  }

  loadCache(String key, Function callback) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? cacheData = prefs.getString(key);
      if (cacheData == null) {
        return;
      } else {
        dynamic decoded = json.decode(cacheData);
        callback(decoded);
      }
    } catch (e) {
      print("---> There is an error on loadCache(). Don't throw error. Slently ignore. $e");
    }
  }

  saveCache(String key, dynamic data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(data);
      await prefs.setString(key, encoded);
    } catch (e) {
      print("---> There is an error on saveCache(). Don't throw error. Slently ignore.");
    }
  }

  // 백엔드에 요청
  //
  // [route] 와 [data] 에 요청 값을 넣고 백엔드로 요청
  //
  // 예제: 백엔드 버전 가져오기
  // ```dart
  // final res = await Api.instance.request('app.version');
  // print('version: ${res['version']}');
  // ```
  Future<dynamic> request(
    String route, {
    MapStringDynamic? data,
    bool debugUrl = false,
    Function? cacheCallback,
    String? cacheKey,
  }) async {
    if (url == '') throw 'Wordpress Api URL is not set.';
    if (data == null) data = {};
    data['route'] = route;
    if (sessionId != '') data['session_id'] = sessionId;

    if (debugUrl) _printDebugUrl(data);

    if (cacheCallback != null) {
      loadCache(getCacheKey(data, cacheKey), cacheCallback);
    }

    ///
    try {
      final res = await dio.post(
        url,
        data: data,
        onSendProgress: (int sent, int total) {
          // print('sent: $sent total: $total');
        },
      );
      if (res.data == null) {
        throw ("Response of backend is NULL.");
      }
      if (res.data is String) {
        print(res);
        _printDebugUrl(data);
        throw "Got response from backend. But the response data is wrong or corrupted. Check if you have proper backend url, or check if the backend produces error.";
      }
      if (res.data['code'] != '') {
        // ! 사용자 실수로 인해 발생하는 에러. 화면에 표시를 해야 한다.
        throw res.data['code'];
      } else if (res.data['response'] == null) {
        throw ("Data inside response object is NULL.");
      } else {
        // 성공. 결과 데이터만 리턴.
        if (cacheCallback != null) saveCache(getCacheKey(data, cacheKey), res.data['response']);
        return res.data['response'];
      }
    } on DioError catch (e) {
      // Something happened in setting up or sending the request to backend, and that triggered an Error
      // Usually, this is an error of Dio itself or [5xx] internal error from server.
      _printLongString(e.message);
      _printDebugUrl(data);

      // 백엔드에서 에러 발생.
      //
      // 백엔드로 접속이 되었으나 2xx 또는 304 가 아닌 다른 응답 코드가 발생한 경우.
      if (e.response != null) {
        final res = e.response as Response;
        final data = res.data;
        if (data is String) {
          if (data.contains('File not found')) {
            throw "PHP script file not found. Check if the PHP-FPM indicates right path of the PHP script. This happens when the API script path was given incorrectly.";
          }
        }
        throw data;
      } else {
        rethrow;
      }
    }
  }

  /// Print Long String
  _printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((RegExpMatch match) => print(match.group(0)));
  }

  // 디버그 URL 출력
  //
  // 백엔드로 부터 원하는 결과가 도착하지 않을 때, 실제로 백엔드로 접속할 수 있는 URL 을 Debug console 에 출력한다.
  // ignore: unused_element
  _printDebugUrl(data) {
    Map<String, dynamic> params = {};
    data.forEach((k, v) {
      if (v is int || v is double) v = v.toString();
      params[k] = v;
    });

    try {
      String queryString = Uri(queryParameters: params).query;
      debugPrint("Restful Api Error URL ==>> $url?$queryString", wrapWidth: 1024);
    } catch (e) {
      print("==> Caught error on _printDebug() with data: ");
      print(data);
    }
  }

  /// DioError 관련 에러인지 확인한다.
  // String knownError(DioError e) {
  //   // 백엔드 호스트 오류. 접속 불가.
  //   if (e.message.indexOf('Failed host lookup') > -1) {
  //     return ERROR_DIO_FAILED_HOST_LOOK_UP;
  //     // return "App cannot connect to backend at '$url'. Check if the host is correct, and if the phone has internet.";
  //   } else if (e.message.indexOf('CERTIFICATE_VERIFY_FAILED') > -1) {
  //     return ERROR_DIO_CERTIFICATE_VERIFY_FAILED;
  //     // return "Certificate error. Check if the app uses correct url scheme. CERTIFICATE_VERIFY_FAILED: application verification failure.";
  //   } else if (e.message.indexOf('Unexpected character') > -1) {
  //     return ERROR_DIO_NOT_JSON_RESPONSE;
  //     // return "PHP script in backend produced error at $url. Check PHP script.";
  //   } else {
  //     return '';
  //   }
  // }
}
