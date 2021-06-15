import 'package:widgets/widgets.dart';
import 'package:youngja/services/globals.dart';
import 'package:youngja/widgets/layout.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '회원 정보',
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.blueGrey[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '회원 정보 수정',
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey[50],
              child: UserProfileForm(
                  success: (user) => service.alert('회원 정보 수정', '회원 정보를 수정하였습니다.'),
                  error: service.error),
            ),
          ],
        ),
      ),
    );
  }
}
