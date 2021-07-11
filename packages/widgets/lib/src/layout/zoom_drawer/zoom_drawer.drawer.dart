import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoomDrawerDrawer extends StatelessWidget {
  const ZoomDrawerDrawer({
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
              padding: EdgeInsets.all(16.0),
              color: Colors.yellow[500],
              child: Text('사용자 아이콘, 이름, 프로필 정보'),
            ),
            Divider(color: Colors.grey, thickness: 1),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (kDebugMode)
                      DrawerItem(
                        iconData: Icons.developer_board,
                        title: '개발 모드 테스트 메뉴',
                        color: Colors.grey[100]!,
                        onTap: () => true,
                      ),
                    DrawerItem(
                      iconData: Icons.home_filled,
                      title: '홈',
                      color: Colors.grey[900]!,
                      onTap: () => print('home clicked @todo 전체 drawer 를 위젯으로 받기'),
                    ),
                    DrawerItem(
                      iconData: Icons.info_outline,
                      title: '어바웃 페이지',
                      color: Colors.grey[100]!,
                      onTap: () => print('about clicked! @todo 전체 drawer 를 위젯으로 받기'),
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
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            Icon(iconData, size: 25),
            SizedBox(width: 6),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
