import 'package:get/get.dart';
import 'package:x_flutter/x_flutter.dart';

class AppController extends GetxController {
  final Api api = Api.instance;

  String version = '0.0.0';
  String time = '';

  @override
  onInit() {
    super.onInit();
    api.init(url: "https://flutterkorea.com/index.php");

    /// 아래의 코드를 적당한 곳으로 이동.
    /// Matrix 백엔드 기본 정보.
    Future.wait([
      api.version().then((res) => version = res.version),
      api.time().then((res) => time = res.time),
    ]).then((value) => update());
  }
}
