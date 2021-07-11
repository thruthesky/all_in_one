import 'package:about_phone/about_phone.dart';
import 'package:all_in_one/controllers/app.controller.dart';
import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:all_in_one/widgets/app.icon.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:calculator/calculator.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
import 'package:utils/utils.dart';
import 'package:weather/weather.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

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
            margin: EdgeInsets.all(sm),
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
                      style: tsTitle,
                    ),
                    Text(
                      ' 일상을 책임지겠습니다.',
                      style: tsTitle,
                    ),
                  ]),
                  NotLoggedIn(builder: (_) => Text('로그인 하기'), onTap: service.openLogin),
                  spaceXl,
                  Text('위젯', style: tsSm),
                  Divider(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BatteryDisplay(),
                          Today(),
                        ],
                      ),
                      Spacer(),
                      WeatherIcon(onTap: () => service.open(RouteNames.weather)),
                    ],
                  ),
                  spaceXl,
                  Text('일상 생활', style: tsSm),
                  Divider(),
                  Wrap(
                    spacing: md,
                    runSpacing: md,
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
                    runSpacing: md,
                    children: [
                      AppIcon(icon: Elusive.qrcode, label: 'QR 코드', action: RouteNames.qrCodeScan),
                      AppIcon(
                          icon: FontAwesome5.codepen,
                          label: 'QR 생성',
                          action: RouteNames.qrCodeGenerate),
                      // AppIcon(icon: Icons.font_download_outlined, label: '구글 폰트', action: () {}),
                      // AppIcon(icon: Icons.font_download_outlined, label: '환율', action: () {}),
                      AppIcon(
                        child: svg('icon/money-exchange', width: 36, height: 36),
                        label: '환율',
                        action: RouteNames.exchangeRate,
                      ),
                      AppIcon(
                          icon: Typicons.globe_alt, label: '국가 정보', action: RouteNames.countryInfo),
                      AppIcon(
                          icon: Icons.phonelink_setup_rounded,
                          label: '핸드폰 정보',
                          action: RouteNames.aboutPhone),
                      AppIcon(
                        icon: Icons.record_voice_over,
                        label: '음성 녹음',
                        action: RouteNames.voiceRecorder,
                      )
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
                      AppIcon(
                          icon: FontAwesome5.info_circle, label: '어바웃', action: RouteNames.about),
                      AppIcon(icon: FontAwesome5.share_alt_square, label: '공유하기', action: () {}),
                      AppIcon(
                          icon: Icons.contacts_rounded, label: '연락처', action: RouteNames.contact),
                      AppIcon(icon: Icons.border_color_rounded, label: '기능 요청', action: () {}),
                      AppIcon(icon: FontAwesome5.tools, label: '준비중', action: RouteNames.beta),
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

class Today extends StatelessWidget {
  const Today({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lu = CalendarConverter.solarToLunar(2021, 06, 28, Timezone.Korean);
    final lunarText = "${lu[2]}년 ${lu[1]}월 ${lu[0]}일";

    final to = DateTime.now();
    final todayText = "${to.year}년 ${to.month}월 ${to.day}일";

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("오늘 날짜: $todayText"),
          Text("오늘 음력: $lunarText"),
        ],
      ),
    );
  }
}
