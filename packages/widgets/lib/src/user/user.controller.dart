import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:x_flutter/x_flutter.dart';

/// todo 이 controller 는 x_flutter 로 들어가야 하지 않나?
class UserController extends GetxController {
  static UserController get to => Get.find();
  static UserController get of => Get.find();
  final box = GetStorage();

  final Api api = Api.instance;
  UserModel loginUser = UserModel.init();
  UserModel get my => loginUser;

  bool get loggedIn => loginUser.idx > 0;
  bool get notLoggedIn => !loggedIn;

  @override
  onInit() {
    print("=== >>> UserController::onInit()");
    super.onInit();

    /// 캐시된 사용자 정보를 읽어 초기화
    final re = box.read('user');
    if (re != null) {
      loginUser = UserModel.fromJson(re);

      /// 먼저, 화면에 그리고
      update();

      /// 백엔드에서 최신 정보로 업데이트.
      profile();
    }
  }

  register(Map<String, dynamic> data) async {
    loginUser = await api.user.register(data);
    setUser(loginUser);
  }

  login(Map<String, dynamic> data) async {
    loginUser = await api.user.login(data);
    setUser(loginUser);
  }

  profileUpdate(Map<String, dynamic> data) async {
    loginUser = await api.user.update(data);
    setUser(loginUser);
  }

  /// 회원 정보를 가져와서 [user] 에 보관한다.
  ///
  /// 앱이 처음 부팅을 할 때, 로컬에 저장된 회원 정보를 로드하는데, 이 때, 이 함수를 한번 호출하여
  /// 백엔드의 최신 정보로 [user] 를 업데이트하고 다시 로컬에 저장한다.
  ///
  profile() async {
    api.sessionId = loginUser.sessionId;
    loginUser = await api.user.profile();
    setUser(loginUser);
  }

  logout() {
    loginUser = UserModel.init();
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
