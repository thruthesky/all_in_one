import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user.controller.dart';

class UserRegisterForm extends StatelessWidget {
  UserRegisterForm({Key? key, required this.success, required this.error}) : super(key: key);

  final Function success;
  final Function error;
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (_) => Container(
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
                    final user = await _.register({
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
      ),
    );
  }
}
