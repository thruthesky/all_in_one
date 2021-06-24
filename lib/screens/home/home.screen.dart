import 'package:all_in_one/controllers/app.controller.dart';
import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:calculator/calculator.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
import 'package:weather/weather.dart';
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
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(xs),
            // color: Colors.white,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('만능앱'),
                  Row(children: [
                    UserName(
                      defaultName: '회원',
                    ),
                    Text('님의 일상을 책임지겠습니다.')
                  ]),
                  svg('face/devil'),
                  spaceXl,
                  Text('자주 사용하는 기능', style: tsSm),
                  Divider(),
                  spaceXl,
                  Text('위젯', style: tsSm),
                  Divider(),
                  WeatherIcon(onTap: () => service.open(RouteNames.weather)),
                  spaceXl,
                  Text('일상 생활', style: tsSm),
                  Divider(),
                  Wrap(
                    spacing: sm,
                    children: [
                      Calculator(
                        child: IconText(
                          icon: FontAwesome5.calculator,
                          label: '계산기',
                          size: 40,
                        ),
                      ),
                      AppIcon(Typicons.sun, '날씨', RouteNames.weather),
                      AppIcon(FontAwesome5.map_marked_alt, '지도', RouteNames.map),
                    ],
                  ),
                  spaceXl,
                  Text('유틸리티, 툴 모음', style: tsSm),
                  Divider(),
                  Wrap(
                    spacing: sm,
                    children: [
                      AppIcon(Elusive.qrcode, 'QR 코드', RouteNames.qrCodeScan),
                      AppIcon(FontAwesome5.codepen, 'QR 생성', RouteNames.qrCodeGenerate),
                      AppIcon(Icons.font_download_outlined, '구글 폰트', () {}),
                      AppIcon(Icons.font_download_outlined, '환율', () {}),
                    ],
                  ),
                  spaceXl,
                  Text('커뮤니티, 게시판', style: tsSm),
                  Divider(),
                  Wrap(
                    spacing: sm,
                    children: [
                      AppIcon(Entypo.chat, '자유게시판', RouteNames.forum,
                          arguments: {'categoryId': 'discussion'}),
                      AppIcon(Icons.help_outline, '질문게시판', RouteNames.forum,
                          arguments: {'categoryId': 'qna'}),
                      AppIcon(Entypo.docs, '공지사항', RouteNames.forum,
                          arguments: {'categoryId': 'reminder'}),
                    ],
                  ),
                  spaceXl,
                  Text('만능앱에 대해서', style: tsSm),
                  Divider(),
                  Wrap(
                    spacing: sm,
                    children: [
                      AppIcon(FontAwesome5.share_alt_square, '공유하기', () => {}),
                      AppIcon(Icons.contacts_rounded, '연락처', RouteNames.contact),
                      AppIcon(Icons.border_color_rounded, '기능 요청', () => {}),
                    ],
                  ),
                  Divider(),
                  WidgetCollection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, this.label, this.action, {Key? key, this.arguments}) : super(key: key);
  final IconData icon;
  final String label;
  final dynamic action;
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context) {
    return IconTextButton(icon, label, () {
      if (action is String)
        service.open(action, arguments: arguments);
      else
        action();
    }, size: 40);
  }
}
