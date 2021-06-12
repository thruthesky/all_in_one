import 'package:flutter/material.dart';

class AioAppBar extends StatefulWidget with PreferredSizeWidget {
  AioAppBar({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _AioAppBarState createState() => _AioAppBarState();
}

class _AioAppBarState extends State<AioAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title ?? '앱 타이틀 바'),
      elevation: 0,
    );
  }
}
