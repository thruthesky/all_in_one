import 'package:analytics/analytics.dart';

import '../services/route_names.dart';
import 'package:get/get.dart';

class ApPostListController extends GetxController {
  String version = '0.0.0';
  String time = '';

  RxString routeName = RouteNames.home.obs;

  @override
  onInit() {
    // print('---> ApPostListController::onInit()');
    super.onInit();

    /// 파이어베이스 애널리스틱. 앱 시작 할 때 로그.
    /// 이 코드는 상태관리와 상관이 없다. 그래서 다른곳으로 이동되어야 한다.
    Analytics.logAppOpen();

    routeName.listen((String routeName) {
      /// 파이어베이스 애널리스틱스. 페이지가 바뀔 때마다 로그
      Analytics.setCurrentScreen(routeName);
    });
  }
}
