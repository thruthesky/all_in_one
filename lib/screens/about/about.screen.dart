import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '어바웃',
      body: Padding(
        padding: EdgeInsets.all(md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('어바웃 페이지'),
            Text('Matrix 버전: ${app.version}'),
            Text('Matrix 서버 URL: ${Api.instance.url}'),
          ],
        ),
      ),
    );
  }
}
