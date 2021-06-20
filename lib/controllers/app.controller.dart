import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:get/get.dart';
import 'package:services/services.dart';
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
  List<CategoryModel>? categories;

  @override
  onInit() {
    super.onInit();
    api.init(
        url: Config.serverUrl,
        anonymousIconUrl:
            'https://flutterkorea.com/view/flutterkorea/assets/icon/anonymous/anonymous.png');

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
      categories = await api.category.gets(Config.categories);
    } catch (e) {
      alert('에러', '게시판 정보를 가져오지 못했습니다.');
    }
  }
}
