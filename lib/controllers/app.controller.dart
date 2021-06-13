import 'package:all_in_one/services/config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:x_flutter/x_flutter.dart';

class App extends GetxController {
  final box = GetStorage();

  final Api api = Api.instance;
  UserModel user = UserModel.init();

  bool get loggedIn => user.idx > 0;
  bool get notLoggedIn => !loggedIn;

  String version = '0.0.0';
  String time = '';

  @override
  onInit() {
    super.onInit();
    api.init(serverUrl: Config.serverUrl);

    /// 캐시된 사용자 정보를 읽어 초기화
    final re = box.read('user');
    if (re != null) {
      user = UserModel.fromJson(re);

      /// 먼저, 화면에 그리고
      update();

      /// 백엔드에서 최신 정보로 업데이트.
      profile();
    }

    /// 아래의 코드를 적당한 곳으로 이동.
    /// Matrix 백엔드 기본 정보.
    Future.wait([
      api.version().then((res) => version = res.version),
      api.time().then((res) => time = res.time),
    ]).then((value) => update());
  }

  register(Map<String, dynamic> data) async {
    user = await api.user.register(data);
    setUser(user);
  }

  login(Map<String, dynamic> data) async {
    user = await api.user.login(data);
    setUser(user);
  }

  profileUpdate(Map<String, dynamic> data) async {
    user = await api.user.update(data);
    setUser(user);
  }

  /// 회원 정보를 가져와서 [user] 에 보관한다.
  ///
  /// 앱이 처음 부팅을 할 때, 로컬에 저장된 회원 정보를 로드하는데, 이 때, 이 함수를 한번 호출하여
  /// 백엔드의 최신 정보로 [user] 를 업데이트하고 다시 로컬에 저장한다.
  ///
  profile() async {
    api.sessionId = user.sessionId;
    user = await api.user.profile();
    setUser(user);
  }

  logout() {
    user = UserModel.init();
    unsetUser();
  }

  /// 회원 정보를 로컬(앱 내 저장 공간)에 저장하고, Api 에 session 정보를 지정한다.
  /// 그리고 다시 화면을 그린다.
  setUser(UserModel user) {
    box.write('user', user);
    api.sessionId = user.sessionId;
    update();
  }

  unsetUser() {
    box.remove('user');
    update();
  }
}
