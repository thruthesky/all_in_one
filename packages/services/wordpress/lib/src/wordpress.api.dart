import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'user.dart';
import '../defines.dart';

class WordpressApi {
  final dio = Dio();

  /// [url] 은 [init] 함수에서 초기화 되어야 한다.
  String url = '';

  String get sessionId => User.instance.currentUser.sessionId;

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

  init({
    required String url,
    Function? onLogin,
    Function? onRegister,
  }) {
    this.url = url;
    this.onLogin = onLogin;
    this.onRegister = onRegister;
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
  Future<dynamic> request(String route, [Json? data]) async {
    if (url == '') throw 'Wordpress Api URL is not set.';
    if (data == null) data = {};
    data['route'] = route;
    if (sessionId != '') data['sessionId'] = sessionId;
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
        throw "Got response from backend. But the response data is wrong or corrupted. Check if you have proper backend url, or check if the backend produces error.";
      }
      if (res.data['code'] != '') {
        throw res.data['code'];
      } else if (res.data['response'] == null) {
        throw ("Data inside response object is NULL.");
      } else {
        // 성공
        return res.data['response'];
      }
    } on DioError catch (e) {
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
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);

        // 백엔드 호스트 오류. 접속 불가.
        if (e.message.indexOf('Failed host lookup') > -1) {
          throw "App cannot connect to backend at '$url'. Check if the host is correct, and if the phone has internet.";
        } else if (e.message.indexOf('CERTIFICATE_VERIFY_FAILED') > -1) {
          throw "Certificate error. Check if the app uses correct url scheme. CERTIFICATE_VERIFY_FAILED: application verification failure.";
        } else if (e.message.indexOf('Unexpected character') > -1) {
          _printDebugUrl(data);
          throw "PHP script in backend produced error at $url. Check PHP script.";
        } else {
          rethrow;
        }
      }
    } catch (e) {
      // 모든 에러를 캐치
      _printDebugUrl(data);
      rethrow;
    }
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
}