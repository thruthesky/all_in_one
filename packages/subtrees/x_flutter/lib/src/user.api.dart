import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_flutter/x_flutter.dart';

/// [UserApi]는 내부적으로 사용자 정보를 관리해서 보다 많이 사용 될 것 같아 singleton 으로 만들었다.
///
class UserApi {
  /// [api]는 api.dart 에서 초기화. 즉, Api 가 먼저 초기화 되어야만 한다.
  Api get api => Api.instance;

  /// 사용자 정보
  UserModel model = UserModel();

  bool get loggedIn => model.loggedIn;
  bool get notLoggedIn => !loggedIn;

  /// 사용자 이름
  ///
  /// 사용법
  /// ```dart
  /// Api.instance.user.name // Api.instance 를 통한 참조
  /// UserApi.instance.name // UserApi.instance 를 통한 참조
  /// ```
  String get name => model.name;
  int get idx => model.idx;
  String get sessionId => model.sessionId;
  String get email => model.email;
  int get point => model.point;
  String get address => model.address;

  /// [changes] 이벤트는 회원 정보의 변경에 따라 발생
  ///
  /// 회원 가입, 로그인, 로그아웃, 서버로 부터 프로필 읽기, 프로필 수정 등, 회원 정보 상태의 변경이 있으면 이벤트가 발생한다.
  BehaviorSubject<UserModel> changes = BehaviorSubject.seeded(UserModel());
  UserApi() {
    print("UserApi::constructor");
    _initUserLogin();
  }

  /// UserApi Singleton
  static UserApi? _instance;
  static UserApi get instance {
    if (_instance == null) {
      print("static UserApi constructor for Singleton");
      _instance = UserApi();
    }

    return _instance!;
  }

  _initUserLogin() async {
    model = await _loadUser();

    /// 로컬 캐시에 있는 데이터가 로드되는데로 changes 가 호출된다.
    changes.add(model);
    if (loggedIn) {
      await profile();
      changes.add(model);
    }
  }

  /// 로그인을 하지 않은 상태이면, 빈 UserModel 을 리턴한다.
  Future<UserModel> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user == null) return UserModel();
    Map<String, dynamic> json = jsonDecode(user);
    return UserModel.fromJson(json);
  }

  /// 회원 정보를 앱내에 저장하고, [changes] 이벤트를 발생한다.
  Future<UserModel> _saveUser(dynamic res) async {
    model = UserModel.fromJson(res);
    changes.add(model);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(model.toJson()));
    return model;
  }

  /// 회원 가입
  ///
  /// [data] 에는 `email`, `password`, `name` 등의 `_users` 테이블 필드 외에 NoSQL 처럼 임의의 값을 저장 할 수 있다.
  Future register(Map<String, dynamic> data) async {
    final res = await api.request('user.register', data);
    return _saveUser(res);
  }

  /// 회원 로그인
  ///
  /// 회원 가입 뿐만아니라, 로그인을 할 때에도 [data] 에 NoSQL 처럼 임의의 값을 저장 할 수 있다.
  Future login(Map<String, dynamic> data) async {
    final res = await api.request('user.login', data);
    return _saveUser(res);
  }

  /// 회원 정보(프로필) 가져오기
  ///
  /// [data] 에 NoSQL 처럼 임의의 값을 저장 할 수 있다.
  ///
  /// 참고, 현재 로그인한 사용자의 프로필을 가져온다. 만약, [sessionId] 에 사용자 세션 정보가 없으면 에러가 난다.
  /// 그래서, 이 함수를 호출 하기 전에 [sessionId] 에 값을 넣어 주어야 한다.
  Future profile() async {
    assert(sessionId != '', "앗, 사용자 세션 아이디가 지정되지 않았습니다.");
    final res = await api.request('user.profile');
    return _saveUser(res);
  }

  /// 회원 정보 수정
  ///
  /// [data] 에 NoSQL 처럼 임의의 값을 저장 할 수 있다.
  Future update(Map<String, dynamic> data) async {
    final res = await api.request('user.update', data);
    return _saveUser(res);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    model = UserModel();
    changes.add(model);
  }
}
