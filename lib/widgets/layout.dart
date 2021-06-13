import 'dart:async';

import 'package:all_in_one/services/defines.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/aio.appbar.dart';
import 'package:all_in_one/widgets/app.drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class Layout extends StatefulWidget {
  Layout({Key? key, this.title = '', required this.body}) : super(key: key);

  final String title;
  final Widget body;

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  late final ZoomDrawerController drawerController;

  late final StreamSubscription screenChanges;
  @override
  void initState() {
    super.initState();
    drawerController = ZoomDrawerController();
    screenChanges = service.screenChanges.listen((routeName) {
      drawerController.close!();
    });
  }

  @override
  void dispose() {
    super.dispose();
    screenChanges.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: drawerController,
      style: DrawerStyle.Style1,
      showShadow: true,
      angle: 0,
      backgroundColor: Colors.grey[300]!,
      slideWidth: MediaQuery.of(context).size.width * .6,
      menuScreen: Scaffold(backgroundColor: primaryColor, body: SafeArea(child: AppDrawer())),
      mainScreen: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppTitle(title: widget.title),
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: widget.body, // 스크린 화면
                        onPanUpdate: (details) {
                          // Drawer 메뉴 오픈을 6 픽셀 이상하면,
                          if (details.delta.dx > 6 && drawerController.isOpen!() == false) {
                            drawerController.open!();
                          } else if (details.delta.dx < 6 && drawerController.isOpen!()) {
                            drawerController.close!();
                          }
                        },
                      ),
                      // @todo 게시판의 경우, 글 쓰기 버튼 표시
                      // FloatingButton(widget.forum),
                    ],
                  ),
                ),
                // SafeArea(child: BottomMenus()),
              ],
            ),
          ),
          // 검색 버튼이 눌러지면, 검색 레이어를 뛰울 것.
          // SearchLayer(),
        ],
      ),
      borderRadius: 24.0,
    );

    // return Scaffold(
    //   appBar: AppTitle(
    //     title: widget.title,
    //   ),
    //   body: widget.body,
    // );
  }
}
