import 'package:analytics/analytics.dart';

import '../services/config.dart';
import '../services/route_names.dart';
import 'package:get/get.dart';
import 'package:utils/utils.dart';
import 'package:x_flutter/x_flutter.dart';

class AppController extends GetxController {
  final Api api = Api.instance;

  String version = '0.0.0';
  String time = '';

  RxString routeName = RouteNames.home.obs;

  /// 앱에서 사용하는 카테고리
  ///
  /// ```
  /// if (_.categories != null) for (final cat in _.categories!) Text('${cat.title}'),
  /// ```
  late CategoriesModel categories;

  @override
  onInit() {
    super.onInit();

    /// 파이어베이스 애널리스틱. 앱 시작 할 때 로그.
    Analytics.logAppOpen();

    ///
    api.init(
      url: Config.serverUrl,
      anonymousIconUrl: Config.anonymousUrl,
      onLogin: (UserModel u) {
        /// 파이어베이스 애널리스틱스. 로그인 할 때 로그
        Analytics.logLogin(loginMethod: 'email');
      },
      onRegister: (UserModel u) {
        /// 파이어베이스 애널리스틱스. 회원 가입 할 때 로그
        Analytics.logSignUp(signUpMethod: 'email');
      },
    );

    routeName.listen((String routeName) {
      /// 파이어베이스 애널리스틱스. 페이지가 바뀔 때마다 로그
      Analytics.setCurrentScreen(routeName);
    });

    /// 아래의 코드를 적당한 곳으로 이동.
    /// Matrix 백엔드 기본 정보.
    Future.wait([
      api.version().then((res) => version = res.version),
      api.time().then((res) => time = res.time),
    ]).then((value) => update());

    initForum();
  }

  initForum() async {
    try {
      categories = await CategoryApi.instance.gets(Config.categories);
    } catch (e) {
      alert('에러', '게시판 정보를 가져오지 못했습니다.\n\n$e');
    }
  }
}
