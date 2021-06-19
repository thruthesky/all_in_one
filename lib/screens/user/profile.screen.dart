import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '회원 정보',
      body: Container(
        padding: EdgeInsets.all(md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(xl),
              color: Colors.grey[50],
              child: UserProfileForm(
                  success: (user) =>
                      service.alert('회원 정보 수정', '회원 정보를 수정하였습니다.'),
                  error: service.error),
            ),
          ],
        ),
      ),
    );
  }
}
