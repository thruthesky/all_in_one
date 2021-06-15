import 'package:all_in_one/services/defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:widgets/widgets.dart';

class Layout extends StatelessWidget {
  Layout({Key? key, this.title = '', required this.body}) : super(key: key);

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: this.title,
      body: this.body,
      drawerHeaderColor: primaryColor,
    );
  }
}
