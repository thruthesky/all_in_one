import 'package:flutter/material.dart';
import 'package:user/user.dart';

class UserProfileForm extends StatelessWidget {
  UserProfileForm({Key? key, required this.success, required this.error}) : super(key: key);

  final Function success;
  final Function error;

  final name = TextEditingController(text: UserController.of.my.name);
  final address = TextEditingController(text: UserController.of.my.address);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('로그인 이메일'),
        Text(UserController.of.my.email),
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
                final user = await UserController.to
                    .profileUpdate({'name': name.text, 'address': address.text});
                success(user);
              } catch (e) {
                error(e);
              }
            },
            child: Text('회원 정보 수정'))
      ],
    );
  }
}
