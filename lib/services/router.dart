//
// 이 클래스는 .generate() 를 통해 페이지(스크린)가 변경 될 때 마다 원하는 작업을 한다.
// 그리고 didPop() 을 통해서 back 버튼을 누르거나 현재 페이지를 벗어 날 때, 원하는 작업을 한다.
import 'package:all_in_one/screens/about/about.screen.dart';
import 'package:all_in_one/screens/home/home.screen.dart';
import 'package:all_in_one/screens/memo/memo.screen.dart';
import 'package:all_in_one/screens/qr_code/qr_code.generate.screen.dart';
import 'package:all_in_one/screens/qr_code/qr_code.result.dart';
import 'package:all_in_one/screens/qr_code/qr_code.scan.dart';
import 'package:all_in_one/screens/user/login.screen.dart';
import 'package:all_in_one/screens/user/profile.screen.dart';
import 'package:all_in_one/screens/user/register.screen.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRouter extends NavigatorObserver {
  static Map<String, GetPageRoute> navStack = {};

  /// 라우트 경로에 맞는 스크린 위젯
  static final Map<String, Widget> screens = {
    RouteNames.home: HomeScreen(),
    RouteNames.about: AboutScreen(),
    RouteNames.login: LoginScreen(),
    RouteNames.register: RegisterScreen(),
    RouteNames.profile: ProfileScreen(),
    RouteNames.memo: MemoScreen(),
    RouteNames.qrCodeGenerate: QrCodeGenerateScreen(),
    RouteNames.qrCodeScan: QrCodeScanScreen(),
    RouteNames.qrCodeResult: QrCodeResult(),
  };

  /// GetMaterialApp( onGenerateRoute: AppRouter.generate ) 에 사용되는 함수.
  /// 새로운 스크린으로 이동 할 때 마다 실행.
  static GetPageRoute generate(RouteSettings routeSettings) {
    /// 새로운 페이지의 라우트 이름
    final routeName = _getRouteName(routeSettings);

    // 특정 라우트(또는 게시판)이 nav stack 에 존재하면 뺀다.
    // 즉, 요점은 nav stack 에 페이지(스크린)가 이미 들어가 있으면, 즉, 이미 방문한 페이지이면, 빼는 것이다.
    if (navStack[routeName] != null) {
      navigator!.removeRoute(navStack[routeName]!);
    }

    /// 라우트 경로에 맞는 스크린(페이지)를 nav stack 에 보관하는데,
    /// 요점은, 게시판인 경우, 카테고리가 합쳐져 유일한 route 경로로 nav stack 에 보관한다.
    navStack[routeName!] = GetPageRoute(
      settings: routeSettings,
      routeName: routeSettings.name,
      page: () => screens[routeSettings.name]!,
    );

    /// 그리고 스크린(페이지 위젯)을 리턴하면 된다.
    return navStack[routeName]!;
  }

  /// GetMaterialApp( navigatorObservers: [ ] ) 에 등록해 주면, didPop() 이 호출된다.
  /// 스크린 돌아가기에서는 실제 Route nav stack 에서는 빠졌지만, 직접 관리하는 navStack 에서는 빠지지
  /// 않았으므로, 빼 준다.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = _getRouteName(route.settings);
    navStack.remove(routeName);
  }

  /// 새로운 페이지로 이동 할 때, 라우트 이름 리턴
  ///
  /// 참고로, 게시판인 경우, 하나의 스크린에서 여러 종류의 게시판이 보여진다. 즉, 라우트가 동일한데 게시판이 다르다.
  /// 이아 같은 경우, forum-qna, forum-discussion 와 같이 유일한 값으로 임시 라우트를 만들어 주어야,
  /// 어떤 게시판 카테고리가 스크린에 중복 표시되는지 알고, 그 게시판 스크린을 nav stack 에서 뺄 수 있다.
  /// 즉, 동일한 게시판을 두 개 펼치는 일이 없어진다.
  static String? _getRouteName(RouteSettings settings) {
    var routeName = settings.name;
    if (routeName == RouteNames.forum) {
      // String category = settings.arguments.category!;
      // routeName += args['category'] ?? '';
    }
    return routeName;
  }
}
