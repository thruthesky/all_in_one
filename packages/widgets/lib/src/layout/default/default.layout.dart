import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultLayout extends StatefulWidget {
  const DefaultLayout({
    Key? key,
    required this.title,
    required this.body,
    this.titleStyle = const TextStyle(fontSize: 16),
    this.menuTextStyle = const TextStyle(fontSize: 10),
    required this.drawer,
  }) : super(key: key);

  final String title;
  final Widget body;

  final TextStyle titleStyle;
  final TextStyle menuTextStyle;

  final Widget drawer;
  @override
  _DefaultLayoutState createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key, // Assign the key to Scaffold.
        appBar: AppBar(
          title: Text(widget.title, style: widget.titleStyle),
          leading: navigator!.canPop()
              ? BackButton(
                  color: Colors.black,
                  onPressed: () {
                    Get.back();
                  })
              : SizedBox.shrink(),
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
                    Text('전체메뉴', style: widget.menuTextStyle)
                  ],
                ),
                onPressed: () {
                  _key.currentState!.openEndDrawer();
                },
              ),
            ),
          ],
        ),
        body: widget.body,
        endDrawer: widget.drawer);
  }
}
