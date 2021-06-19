import 'dart:io';

import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

class Layout extends StatelessWidget {
  Layout({Key? key, this.title = '', required this.body}) : super(key: key);

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: Colors.grey[200]!,
      title: this.title,
      titleStyle: TextStyle(color: Colors.black87),
      body: this.body,
      drawer: LayoutDrawer(),
    );
  }
}

class LayoutDrawer extends StatefulWidget {
  const LayoutDrawer({Key? key}) : super(key: key);

  @override
  _LayoutDrawerState createState() => _LayoutDrawerState();
}

class _LayoutDrawerState extends State<LayoutDrawer> {
  open(route) {
    Get.back();
    service.open(route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAvatar(onTap: () => open(RouteNames.profile)),
                Spacer(),
                Row(
                  children: [
                    UserName(defaultName: '로그인을 해 주세요.', onTap: () => open(RouteNames.profile)),
                    Spacer(),
                    UserChange(
                      loginBuilder: (user) => Row(
                        children: [
                          TextButton(onPressed: () => open(RouteNames.profile), child: Text('프로필')),
                          TextButton(
                              onPressed: () => UserApi.instance.logout(), child: Text('로그아웃')),
                        ],
                      ),
                      logoutBuilder: (_) => Row(
                        children: [
                          TextButton(onPressed: () => open(RouteNames.login), child: Text('로그인')),
                          TextButton(
                              onPressed: () => open(RouteNames.register), child: Text('회원가입')),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('홈'),
            onTap: () => service.openHome(),
          ),
          UserChange(
            loginBuilder: (_) => SizedBox.shrink(),
            logoutBuilder: (_) => Column(
              children: [
                ListTile(title: Text('회원 로그인'), onTap: () => open(RouteNames.login)),
                ListTile(title: Text('회원 가입'), onTap: () => open(RouteNames.register)),
              ],
            ),
          ),
          ListTile(title: Text('QR 코드')),
          ListTile(
              leading: spaceXs,
              title: Text('QR 코드 생성'),
              onTap: () => open(RouteNames.qrCodeGenerate)),
          ListTile(
              leading: spaceXs, title: Text('QR 코드 스캔'), onTap: () => open(RouteNames.qrCodeScan)),
          ListTile(
              title: ShareButton(
            text: Platform.isIOS ? Config.iOSAppDownloadUrl : Config.androidAppDownloadUrl,
            child: Text('우리앱을 친구에게 알려주기'),
          )),
          ListTile(title: Text('재 사용 가능한 위젯 보기'), onTap: () => open(RouteNames.widgetCollection)),
          ListTile(title: Text('만능앱에 대해서'), onTap: () => open(RouteNames.about)),
        ],
      ),
    );
  }
}
