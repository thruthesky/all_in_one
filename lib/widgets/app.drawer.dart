import 'package:all_in_one/services/defines.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.58,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(md),
              color: Colors.yellow[500],
              child: Text('사용자 아이콘, 이름, 프로필 정보'),
            ),
            Divider(color: grey, thickness: 1),
            spaceXsm,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (kDebugMode)
                      DrawerItem(
                        iconData: Icons.developer_board,
                        title: '개발 모드 테스트 메뉴',
                        color: light,
                        onTap: () => true,
                      ),
                    DrawerItem(
                      iconData: Icons.home_filled,
                      title: '홈',
                      color: dark,
                      onTap: () => service.openHome(),
                    ),
                    DrawerItem(
                      iconData: Icons.info_outline,
                      title: '어바웃 페이지',
                      color: light,
                      onTap: () => service.openAbout(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.iconData,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final IconData iconData;
  final String title;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(xs),
        child: Row(
          children: [
            Icon(iconData, size: 25),
            spaceXsm,
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
