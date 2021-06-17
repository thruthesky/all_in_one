import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class UserLoginForm extends StatelessWidget {
  UserLoginForm({
    Key? key,
    required this.success,
    required this.error,
  }) : super(key: key);

  final Function success;
  final Function error;
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.orange[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('로그인 이메일:'),
          TextField(controller: email),
          SizedBox(height: 16),
          Text('로그인 비밀번호:'),
          TextField(controller: password),
          SizedBox(height: 16),
          ElevatedButton(
              onPressed: () async {
                try {
                  final user = await UserApi.instance
                      .login({'email': email.text, 'password': password.text});
                  success(user);
                  // service.openHome();
                } catch (e) {
                  error(e);
                  // service.error(e);
                }
              },
              child: Text('회원 로그인'))
        ],
      ),
    );
  }
}
