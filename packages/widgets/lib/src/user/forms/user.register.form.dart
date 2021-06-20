import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

/// 회원 가입 양식
///
/// 회원 가입에 성공하면 [success] 콜백이 호출된다. 콜백 인자로 사용자 모델이 전달된다.
class UserRegisterForm extends StatelessWidget {
  UserRegisterForm({Key? key, required this.success, required this.error}) : super(key: key);

  final Function success;
  final Function error;
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('로그인 이메일:'),
          TextField(controller: email),
          SizedBox(height: 16),
          Text('로그인 비밀번호:'),
          TextField(controller: password),
          SizedBox(height: 16),
          Text('사용자 이름:'),
          TextField(controller: name),
          SizedBox(height: 16),
          ElevatedButton(
              onPressed: () async {
                try {
                  final user = await UserApi.instance.register({
                    'email': email.text,
                    'password': password.text,
                    'name': name.text,
                  });
                  success(user);
                } catch (e) {
                  error(e);
                }
              },
              child: Text('회원 가입'))
        ],
      ),
    );
  }
}
