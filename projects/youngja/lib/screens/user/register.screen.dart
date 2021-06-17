import 'package:widgets/widgets.dart';
import 'package:youngja/services/globals.dart';
import 'package:youngja/widgets/layout.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

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
            Expanded(
                child:
                    UserRegisterForm(success: (user) => service.openHome(), error: service.error)),
          ],
        ),
      ),
    );
  }
}
