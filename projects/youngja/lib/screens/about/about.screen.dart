import 'package:flutter/material.dart';
import 'package:youngja/widgets/layout.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '어바웃',
      body: Text('home'),
    );
  }
}
