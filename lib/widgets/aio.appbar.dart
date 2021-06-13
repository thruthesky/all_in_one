import 'package:all_in_one/services/defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class AioAppBar extends StatefulWidget with PreferredSizeWidget {
  AioAppBar({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _AioAppBarState createState() => _AioAppBarState();
}

class _AioAppBarState extends State<AioAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: navigator!.canPop()
          ? BackButton(
              color: Colors.black,
              onPressed: () {
                Get.back();
              })
          : IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                ZoomDrawer.of(context)!.toggle();
              },
            ),
      title: Text(widget.title, style: tsBlack),
      elevation: 0,
    );
  }
}
