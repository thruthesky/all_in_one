import 'package:all_in_one/controllers/app.controller.dart';
import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/defines.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (_) => Layout(
        title: Config.appName,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Matrix server version: ${_.version}'),
              Text('Matrix server time: ${_.time}'),
              Divider(),
              GetBuilder<UserController>(
                builder: (user) => Column(
                  children: [
                    if (user.loggedIn) Text('회원 이름: ${user.my.name}'),
                    if (user.loggedIn) Text('회원 주소: ${user.my.address}'),
                    Wrap(spacing: sm, alignment: WrapAlignment.spaceBetween, children: [
                      if (user.loggedIn) ...[
                        ElevatedButton(onPressed: user.logout, child: Text('로그아웃')),
                        ElevatedButton(onPressed: service.openProfile, child: Text('회원 정보')),
                      ],
                      if (user.notLoggedIn) ...[
                        ElevatedButton(onPressed: service.openRegister, child: Text('회원가입')),
                        ElevatedButton(onPressed: service.openLogin, child: Text('로그인')),
                      ],
                    ]),
                  ],
                ),
              ),
              Text('기능별 메뉴'),
              Divider(),
<<<<<<< HEAD
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
=======
              Wrap(
                spacing: xs,
>>>>>>> 3b8a9a3b1f95acca94c37c1788dac29f3a09a83c
                children: [
                  ElevatedButton(onPressed: service.openAbout, child: Text('어바웃 페이지')),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.memo),
                    child: Text('메모장'),
                  ),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.game),
                    child: Text('게임'),
                  ),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.boni),
                    child: Text('9BONI'),
                  ),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.gyeony),
                    child: Text('gyeony'),
                  ),
                ],
              ),
              Text('잡다한 메뉴'),
              Divider(),
              ShareButton(
                text: "환상의 나라 필리핀에 오신 것을 환영합니다. https://www.philgo.com",
                child: Text('필고 사이트를 친구에게 공유 해 주세요 ^^;'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.qrCodeGenerate),
                    child: Text('QR 코드 생성'),
                  ),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.qrCodeScan),
                    child: Text('QR 코드 스캔'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
