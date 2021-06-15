import 'package:x_flutter/models/user.model.dart';
import 'package:x_flutter/x_flutter.dart';

class User {
  /// [api]는 api.dart 에서 초기화.
  late final Api api;
  User() {
    print("User::construct ...");
  }

  /// 회원 가입
  ///
  /// [data] 에는 `email`, `password`, `name` 등의 `_users` 테이블 필드 외에 NoSQL 처럼 임의의 값을 저장 할 수 있다.
  Future register(Map<String, dynamic> data) {
    return api
        .request('user.register', data)
        .then((json) => UserModel.fromJson(json));
  }

  /// 회원 로그인
  ///
  /// 회원 가입 뿐만아니라, 로그인을 할 때에도 [data] 에 NoSQL 처럼 임의의 값을 저장 할 수 있다.
  Future login(Map<String, dynamic> data) {
    return api
        .request('user.login', data)
        .then((json) => UserModel.fromJson(json));
  }

  /// 회원 정보(프로필) 가져오기
  ///
  /// [data] 에 NoSQL 처럼 임의의 값을 저장 할 수 있다.
  ///
  /// 참고, 현재 로그인한 사용자의 프로필을 가져온다. 만약, [api.sessionId] 에 사용자 세션 정보가 없으면 에러가 난다.
  /// 그래서, 이 함수를 호출 하기 전에 [api.sessionId] 에 값을 넣어 주어야 한다.
  Future profile() {
    assert(api.sessionId != '', "앗, 사용자 세션 아이디가 지정되지 않았습니다.");
    return api.request('user.profile').then((json) => UserModel.fromJson(json));
  }

  /// 회원 정보 수정
  ///
  /// [data] 에 NoSQL 처럼 임의의 값을 저장 할 수 있다.
  Future update(Map<String, dynamic> data) {
    return api
        .request('user.update', data)
        .then((json) => UserModel.fromJson(json));
  }
}
