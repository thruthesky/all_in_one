import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

/// 사용자 정보 변경을 감지하는 위젯
///
/// [loginBuilder] 는 사용자가 로그인을 했을 때, 실행되는 콜백. 로그인 시, 화면에 표시할 위젯을 빌드하면 됩니다.
/// [logoutBuilder] 는 사용자가 로그아웃을 했을 때, 실행되는 콜백. 로그아웃 시 또는 로그인(가입)을 하지 않은 경우, 화면에 표시할 위젯을 빌드하면 됩니다.
class UserChange extends StatelessWidget {
  UserChange({required this.loginBuilder, required this.logoutBuilder});
  final Function loginBuilder;
  final Function logoutBuilder;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      /// ? distinct() 로 하니, 화면이 깜빡거린다. 왜?
      /// 예) .distinct((p, n) => p.idx == n.idx)
      stream: UserApi.instance.changes,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return SizedBox.shrink();
        UserModel user = snapshot.data as UserModel;

        if (user.loggedIn) {
          return this.loginBuilder(user);
        } else {
          return this.logoutBuilder(user);
        }
      },
    );
  }
}
