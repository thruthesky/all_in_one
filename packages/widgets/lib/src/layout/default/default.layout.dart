import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/src/user/widgets/user.avatar.dart';
import 'package:widgets/src/user/widgets/user.name.dart';

class DefaultLayout extends StatefulWidget {
  const DefaultLayout({
    Key? key,
    required this.title,
    required this.body,
    this.titleStyle = const TextStyle(fontSize: 16),
    this.menuTextStyle = const TextStyle(fontSize: 10),
    this.drawerHeaderColor = Colors.blue,
  }) : super(key: key);

  final String title;
  final Widget body;

  final TextStyle titleStyle;
  final TextStyle menuTextStyle;
  final Color drawerHeaderColor;
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
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: widget.drawerHeaderColor,
              ),
              child: Column(
                children: [
                  UserAvatar(),
                  UserName(),
                ],
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }
}
