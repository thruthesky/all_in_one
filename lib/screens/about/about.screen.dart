import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '어바웃',
      body: Text('어바웃 페이지'),
    );
  }
}
