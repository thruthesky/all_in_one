import 'package:all_in_one/widgets/aio.appbar.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  Layout({Key? key, this.title, required this.body}) : super(key: key);

  final String? title;
  final Widget body;

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AioAppBar(
        title: widget.title,
      ),
      body: widget.body,
    );
  }
}
