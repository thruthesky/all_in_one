import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class Service {
  BuildContext get context => Get.context!;

  /// 싱글톤
  static late Service _instance;
  static bool _ready = false;
  static Service get instance {
    if (_ready) {
      return _instance;
    } else {
      _instance = Service();
      _ready = true;
      return _instance;
    }
  }

  // ignore: close_sinks
  PublishSubject<String> screenChanges = PublishSubject();

  Future open(String routeName, {offAll = false}) {
    screenChanges.add(routeName);
    if (offAll) {
      return Get.offAllNamed(routeName)!;
    } else {
      return Get.toNamed(routeName)!;
    }
  }

  openHome() {
    open(RouteNames.home, offAll: true);
  }

  openAbout() {
    open(RouteNames.about);
  }

  openRegister() {
    open(RouteNames.register);
  }

  openLogin() {
    open(RouteNames.login);
  }

  openProfile() {
    open(RouteNames.profile);
  }

  error(e) {
    print('에러 발생: $e');
    if (!(e is String) && e.message is String) {
      alert('Assertion 에러 발생', e.message);
    } else {
      alert('에러', e);
    }
  }

  // 알림창을 띄운다
  //
  // 알림창은 예/아니오의 선택이 없다. 그래서 리턴값이 필요없다.
  Future<void> alert(String title, String content) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [TextButton(onPressed: () => Get.back(result: true), child: Text('확인'))],
      ),
    );
  }
}
