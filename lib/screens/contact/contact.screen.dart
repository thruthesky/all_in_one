import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
        title: '연락처',
        body: Container(
          child: Text('연락처입니다.'),
        ));
  }
}
