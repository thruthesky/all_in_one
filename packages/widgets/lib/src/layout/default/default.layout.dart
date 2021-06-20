import 'package:flutter/material.dart';

class DefaultLayout extends StatefulWidget {
  const DefaultLayout({
    Key? key,
    required this.appBar,
    required this.body,
    this.backgroundColor = Colors.grey,
    required this.drawer,
  }) : super(key: key);

  final Function appBar;
  final Widget body;

  final Color backgroundColor;

  final Widget drawer;
  @override
  _DefaultLayoutState createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey(); // Create a key
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalScaffoldKey,
        backgroundColor: widget.backgroundColor,
        appBar: widget.appBar(globalScaffoldKey),
        body: widget.body,
        endDrawer: widget.drawer);
  }
}
