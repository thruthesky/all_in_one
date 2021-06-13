import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '회원 가입',
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.orange[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '회원 로그인',
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.orange[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('로그인 이메일'),
                  TextField(controller: email),
                  SizedBox(height: 16),
                  Text('로그인 비밀번호'),
                  TextField(controller: password),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await app.login({'email': email.text, 'password': password.text});
                          service.openHome();
                        } catch (e) {
                          service.error(e);
                        }
                      },
                      child: Text('회원 로그인'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
