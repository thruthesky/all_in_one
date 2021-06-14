import 'package:all_in_one/services/defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class AppTitle extends StatefulWidget with PreferredSizeWidget {
  AppTitle({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _AppTitleState createState() => _AppTitleState();
}

class _AppTitleState extends State<AppTitle> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: navigator!.canPop()
          ? BackButton(
              color: Colors.black,
              onPressed: () {
                Get.back();
              })
          : SizedBox.shrink(),
      title: Text(widget.title, style: tsTitle),
      shape: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        SizedBox(
          width: 52,
          child: IconButton(
            icon: Column(
              children: [
                Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                Text('ALL', style: tsXs)
              ],
            ),
            onPressed: () {
              ZoomDrawer.of(context)!.toggle();
            },
          ),
        ),
      ],
    );
  }
}
