import 'dart:io';

import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

/// Layout
///
/// [create] 에 콜백이 지정되면 "추가" 버튼이 화면에 표시되며, 클릭되면, 해당 콜백이 실행된다.
/// [back] 콜백은 백 버튼을 누른 경우 호출된다. 만약, [back] 콜백이 주어진 경우, 해당 스크린에서 직접 이전 페이지로 이동해야 한다.
///   또는 경우에 따라 이전 페이지로 가지 않거나, 다른 페이지로 가는 등의 처리를 할 수 있다.
///   예제) 게시판에서 글 작성 폼을 열고, 백 버튼을 누르면, 글 작성 폼을 닫는다.
class Layout extends StatelessWidget {
  Layout({
    Key? key,
    this.title = '',
    required this.body,
    this.create,
    this.back,
  }) : super(key: key);

  final String title;
  final Widget body;
  final VoidCallback? create;
  final VoidCallback? back;

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppTitleBar(globalKey: _key, title: title, create: create, back: back),
      body: body,
      endDrawer: LayoutDrawer(),
    );
  }
}

class AppTitleBar extends StatefulWidget with PreferredSizeWidget {
  AppTitleBar({
    Key? key,
    required this.globalKey,
    required this.title,
    this.titleStyle = const TextStyle(fontSize: 16, color: Colors.black),
    this.menuTextStyle = const TextStyle(fontSize: 8, color: Colors.black),
    this.create,
    this.back,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> globalKey;
  final String title;
  final TextStyle titleStyle;
  final TextStyle menuTextStyle;
  final VoidCallback? create;
  final VoidCallback? back;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _AppTitleBarState createState() => _AppTitleBarState();
}

class _AppTitleBarState extends State<AppTitleBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title, style: widget.titleStyle),
      leading: navigator!.canPop()
          ? BackButton(
              color: Colors.black,
              onPressed: () {
                if (widget.back != null) {
                  widget.back!();
                } else {
                  Get.back();
                }
              })
          : SizedBox.shrink(),
      shape: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        Center(
            child: UserAvatar(
                size: 36,
                onTap: UserApi.instance.loggedIn ? service.openProfile : service.openLogin)),
        if (widget.create != null)
          IconButton(
              onPressed: widget.create,
              icon: Column(
                children: [
                  Icon(
                    Icons.add_circle,
                    color: Colors.black,
                    size: 30,
                  ),
                  Text('글쓰기', style: widget.menuTextStyle)
                ],
              )),
        SizedBox(
          width: 52,
          child: IconButton(
            icon: Column(
              children: [
                Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 28,
                ),
                Text(Platform.isAndroid ? '메뉴' : '전체메뉴', style: widget.menuTextStyle)
              ],
            ),
            onPressed: () {
              widget.globalKey.currentState!.openEndDrawer();
            },
          ),
        ),
      ],
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
