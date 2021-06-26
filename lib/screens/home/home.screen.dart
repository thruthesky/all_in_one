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
                      suffixLogin: '님의',
                      defaultName: '당신의',
                    ),
                    Text(' 일상을 책임지겠습니다.'),
                    Text('app_name'.tr),
                    Text('apple'.tr),
                  ]),
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
                    spacing: md,
                    children: [
                      Calculator(
                        child: IconText(
                          icon: FontAwesome5.calculator,
                          label: '계산기',
                          size: 40,
                        ),
                      ),
                      AppIcon(icon: Typicons.sun, label: '날씨', action: RouteNames.weather),
                      AppIcon(
                          icon: FontAwesome5.map_marked_alt, label: '지도', action: RouteNames.map),
                    ],
                  ),
                  spaceXl,
                  Text('유틸리티, 툴 모음', style: tsSm),
                  Divider(),
                  Wrap(
                    spacing: md,
                    children: [
                      AppIcon(icon: Elusive.qrcode, label: 'QR 코드', action: RouteNames.qrCodeScan),
                      AppIcon(
                          icon: FontAwesome5.codepen,
                          label: 'QR 생성',
                          action: RouteNames.qrCodeGenerate),
                      // AppIcon(icon: Icons.font_download_outlined, label: '구글 폰트', action: () {}),
                      // AppIcon(icon: Icons.font_download_outlined, label: '환율', action: () {}),
                      AppIcon(
                        child: svg('money-exchange', package: '..', width: 36, height: 36),
                        label: '환율',
                        action: RouteNames.exchangeRate,
                      ),
                      AppIcon(
                          icon: Typicons.globe_alt, label: '국가 정보', action: RouteNames.countryInfo),
                    ],
                  ),
                  spaceXl,
                  Text('커뮤니티, 게시판', style: tsSm),
                  Divider(),
                  Wrap(
                    spacing: sm,
                    children: [
                      AppIcon(
                          icon: Entypo.chat,
                          label: '자유게시판',
                          action: RouteNames.forum,
                          arguments: {'categoryId': 'discussion'}),
                      AppIcon(
                          icon: Icons.help_outline,
                          label: '질문게시판',
                          action: RouteNames.forum,
                          arguments: {'categoryId': 'qna'}),
                      AppIcon(
                          icon: Entypo.docs,
                          label: '공지사항',
                          action: RouteNames.forum,
                          arguments: {'categoryId': 'reminder'}),
                    ],
                  ),
                  spaceXl,
                  Text('만능앱에 대해서', style: tsSm),
                  Divider(),
                  Wrap(
                    spacing: md,
                    children: [
                      AppIcon(icon: FontAwesome5.share_alt_square, label: '공유하기', action: () => {}),
                      AppIcon(
                          icon: Icons.contacts_rounded, label: '연락처', action: RouteNames.contact),
                      AppIcon(icon: Icons.border_color_rounded, label: '기능 요청', action: () => {}),
                    ],
                  ),
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
  const AppIcon({
    this.icon,
    this.label = '',
    this.action,
    Key? key,
    this.arguments,
    this.child,
  }) : super(key: key);
  final IconData? icon;
  final Widget? child;
  final String label;

  final dynamic action;
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return IconTextButton(icon!, label, () {
        if (action is String)
          service.open(action, arguments: arguments);
        else
          action();
      }, size: 40);
    } else {
      return GestureDetector(
        child: Column(
          children: [
            SizedBox(height: 2),
            child!,
            spaceXs,
            Text(
              label,
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (action is String)
            service.open(action, arguments: arguments);
          else
            action();
        },
      );
    }
  }
}
