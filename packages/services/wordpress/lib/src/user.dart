import 'package:rxdart/rxdart.dart';

import '../models/user.model.dart';
import 'wordpress.api.dart';
import '../defines.dart';

class User {
  /// User Singleton
  static User? _instance;
  static User get instance {
    if (_instance == null) {
      _instance = User();
    }

    return _instance!;
  }

  WPUser currentUser = WPUser.fromJson({});

  /// [changes] 이벤트는 회원 정보의 변경에 따라 발생
  ///
  /// 회원 가입, 로그인, 로그아웃, 서버로 부터 프로필 읽기, 프로필 수정 등, 회원 정보 상태의 변경이 있으면 이벤트가 발생한다.
  BehaviorSubject<WPUser> changes = BehaviorSubject.seeded(WPUser.fromJson({}));

  /// Register a new user.
  ///
  Future<WPUser> register(Json data) async {
    final res = await WordpressApi.instance.request('user.register', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }

  /// Login a user.
  ///
  Future<WPUser> login(Json data) async {
    final res = await WordpressApi.instance.request('user.login', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }

  /// Register or Login a user after social login process
  ///
  ///
  Future<WPUser> loginOrRegister(Map<String, dynamic> params) async {
    // print(params);
    try {
      // print('login');
      var u = await login(params);
      // print(u.toString());
      return u;
    } catch (e) {
      if (e == ERROR_USER_NOT_FOUND_BY_THAT_EMAIL) {
        // print('======> User is not registered in Backend: Going to register');
        try {
          // print('login');
          var u = await register(params);
          // print(u.toString());
          return u;
        } catch (e) {
          throw e;
        }
      } else {
        throw e;
      }
    }
  }

  /// Update user information.
  ///
  Future<WPUser> update(Json data) async {
    final res = await WordpressApi.instance.request('user.update', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }

  logout() async {
    currentUser = WPUser.fromJson({});
    changes.add(currentUser);
  }
}