import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:user/user.dart';
import 'package:youngja/services/globals.dart';
import 'package:youngja/widgets/layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '홈',
      body: GetBuilder<UserController>(
        builder: (_) => Column(
          children: [
            Text("이름: ${_.my.name}"),
            Text("주소: ${_.my.address}"),
            if (_.loggedIn) ElevatedButton(onPressed: _.logout, child: Text('로그아웃')),
            Wrap(alignment: WrapAlignment.spaceBetween, children: [
              ElevatedButton(onPressed: service.openAbout, child: Text('어바웃 페이지')),
              ElevatedButton(onPressed: service.openRegister, child: Text('회원가입')),
              ElevatedButton(onPressed: service.openLogin, child: Text('로그인')),
              ElevatedButton(onPressed: service.openProfile, child: Text('회원 정보')),
            ]),
          ],
        ),
      ),
    );
  }
}
