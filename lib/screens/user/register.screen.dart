import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '회원 가입',
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '회원 가입',
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('로그인 이메일'),
                  TextField(controller: email),
                  SizedBox(height: 16),
                  Text('로그인 비밀번호'),
                  TextField(controller: password),
                  SizedBox(height: 16),
                  Text('사용자 이름'),
                  TextField(controller: name),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await app.register({
                            'email': email.text,
                            'password': password.text,
                            'name': name.text,
                          });
                          service.openHome();
                        } catch (e) {
                          service.error(e);
                        }
                      },
                      child: Text('회원 가입'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
