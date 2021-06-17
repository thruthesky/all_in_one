import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '회원 로그인',
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
            UserLoginForm(
              success: (user) => service.openHome(),
              error: service.error,
            ),
          ],
        ),
      ),
    );
  }
}
