import 'package:rxdart/rxdart.dart';

import '../models/user.model.dart';
import 'wordpress.api.dart';
import '../defines.dart';

class UserApi {
  /// User Singleton
  static UserApi? _instance;
  static UserApi get instance {
    if (_instance == null) {
      _instance = UserApi();
    }

    return _instance!;
  }

  WPUser currentUser = WPUser.fromJson({});

  /// [changes] 이벤트는 회원 정보의 변경에 따라 발생
  ///
  /// 회원 가입, 로그인, 로그아웃, 서버로 부터 프로필 읽기, 프로필 수정 등, 회원 정보 상태의 변경이 있으면 이벤트가 발생한다.
  BehaviorSubject<WPUser> changes = BehaviorSubject.seeded(WPUser.fromJson({}));

  /// [userLogin] event is posted only on login.
  BehaviorSubject<WPUser> userLogin = BehaviorSubject.seeded(WPUser.fromJson({}));

  /// Register a new user.
  ///
  Future<WPUser> register(MapStringDynamic data) async {
    final res = await WordpressApi.instance.request('user.register', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }

  /// Login a user.
  ///
  Future<WPUser> login(MapStringDynamic data) async {
    final res = await WordpressApi.instance.request('user.login', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    userLogin.add(currentUser);
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
  Future<WPUser> update(MapStringDynamic data) async {
    final res = await WordpressApi.instance.request('user.update', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }

  /// Get login user profile.
  ///
  Future<WPUser> profile() async {
    final res = await WordpressApi.instance.request('user.profile');
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }

  /// Cache containers
  Map<int, WPUser> othersById = {};
  Map<String, WPUser> othersByFirebaseUid = {};

  /// Get other user's profile.
  ///
  Future<WPUser> otherProfile({int? userId, String? firebaseUid}) async {
    assert(userId != null || firebaseUid != null);
    if (userId != null) {
      if (othersById[userId] != null) {
        print('other user profile is reused by id; $userId');
        return othersById[userId]!;
      }
    } else if (firebaseUid != null) {
      if (othersByFirebaseUid[firebaseUid] != null) {
        print('other user profile is reused by firebase uid; $firebaseUid');
        return othersByFirebaseUid[firebaseUid]!;
      }
    }

    final res = await WordpressApi.instance.request('user.otherProfile', {
      if (userId != null) 'user_ID': userId,
      if (firebaseUid != null) 'firebaseUid': firebaseUid,
    });

    print('other user profile; $res');

    if (userId != null) {
      othersById[userId] = WPUser.fromJson(res);
      return othersById[userId]!;
    } else if (firebaseUid != null) {
      othersByFirebaseUid[firebaseUid] = WPUser.fromJson(res);
      return othersByFirebaseUid[firebaseUid]!;
    } else {
      throw ERROR_PROFILE_ID_MISSING;
    }
  }

  logout() async {
    currentUser = WPUser.fromJson({});
    changes.add(currentUser);
  }

  /// Update user information.
  ///
  Future<WPUser> switchData(MapStringDynamic data) async {
    final res = await WordpressApi.instance.request('user.switch', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }

  Future<WPUser> switchOn(MapStringDynamic data) async {
    final res = await WordpressApi.instance.request('user.switchOn', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }

  Future<WPUser> switchOff(MapStringDynamic data) async {
    final res = await WordpressApi.instance.request('user.switchOff', data);
    currentUser = WPUser.fromJson(res);
    changes.add(currentUser);
    return currentUser;
  }
}
