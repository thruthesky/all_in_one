import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final name = TextEditingController(text: app.user.my.name);
  final address = TextEditingController(text: app.user.my.address);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('로그인 이메일'),
                  Text(app.user.my.email),
                  SizedBox(height: 16),
                  Text('사용자 이름'),
                  TextField(controller: name),
                  SizedBox(height: 16),
                  Text('주소'),
                  TextField(controller: address),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await app.user
                              .profileUpdate({'name': name.text, 'address': address.text});
                          service.alert('회원 정보 수정', '회원 정보를 수정하였습니다.');
                        } catch (e) {
                          service.error(e);
                        }
                      },
                      child: Text('회원 정보 수정'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
