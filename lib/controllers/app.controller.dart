import 'package:all_in_one/services/config.dart';
import 'package:get/get.dart';
import 'package:user/user.dart';
import 'package:x_flutter/x_flutter.dart';

class AppController extends GetxController {
  final Api api = Api.instance;
  final UserController user = UserController();

  String version = '0.0.0';
  String time = '';

  @override
  onInit() {
    super.onInit();
    api.init(url: Config.serverUrl);
    Get.put(user);

    /// 아래의 코드를 적당한 곳으로 이동.
    /// Matrix 백엔드 기본 정보.
    Future.wait([
      api.version().then((res) => version = res.version),
      api.time().then((res) => time = res.time),
    ]).then((value) => update());
  }
}
