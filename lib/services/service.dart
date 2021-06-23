import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services/services.dart' as s;

class Service {
  BuildContext get context => Get.context!;

  /// 싱글톤
  static Service? _instance;
  static Service get instance {
    if (_instance == null) {
      _instance = Service();
    }
    return _instance!;
  }

  /// 스크린(페이지) 이동
  ///
  /// [offAll] 에 true 가 지정되면, nav stack 의 중간에 있는 모든 페이지를 없애고 해당 페이지로 이동.
  Future? open(String routeName,
      {arguments = const {}, offAll = false, off = false}) {
    app.routeName.value = routeName;
    if (offAll) {
      return Get.offAllNamed(routeName, arguments: arguments);
    } else if (off) {
      return Get.offNamed(routeName, arguments: arguments);
    } else {
      return Get.toNamed(routeName, arguments: arguments);
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

  openMap() {
    open(RouteNames.map);
  }

  error(e) {
    s.error(e);
  }

  // 알림창을 띄운다
  //
  // 알림창은 예/아니오의 선택이 없다. 그래서 리턴값이 필요없다.
  Future<void> alert(String title, String content) async {
    return s.alert(title, content);
  }
}
