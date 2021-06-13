import 'package:all_in_one/controllers/app.controller.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_flutter/x_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String version = '0.0.0';
  String time = '';

  @override
  void initState() {
    super.initState();
    Api.instance.version().then((res) => setState(() => version = res.version));
    Api.instance.time().then((res) => setState(() => time = res.time));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<App>(
      builder: (_) => Layout(
        title: '홈',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Matrix server version: $version'),
              Text('Matrix server time: $time'),
              Divider(),
              if (_.loggedIn) Text('회원 이름: ${_.user.name}'),
              if (_.loggedIn) ElevatedButton(onPressed: _.logout, child: Text('로그아웃')),
              Divider(),
              Wrap(alignment: WrapAlignment.spaceBetween, children: [
                ElevatedButton(onPressed: service.openAbout, child: Text('어바웃 페이지')),
                ElevatedButton(onPressed: service.openRegister, child: Text('회원가입')),
                ElevatedButton(onPressed: service.openLogin, child: Text('로그인')),
                ElevatedButton(onPressed: service.openProfile, child: Text('회원 정보')),
              ]),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
