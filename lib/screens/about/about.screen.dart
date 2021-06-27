import 'package:about/about.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '어바웃',
      body: Padding(
        padding: EdgeInsets.all(md),
        child: AboutDisplay(
          top: Column(
            children: [
              Icon(
                FontAwesome5.tools,
                size: 64,
              ),
              spaceLg,
            ],
          ),
          title: '만능앱',
          developerName: '송재호',
          developerContact: '010-8693-4225',
          developerEmail: 'thruthesky@gmail.com',
          developerKakao: 'thruthesky2',
          matrixVersion: app.version,
          matrixUrl: Api.instance.url,
          bottom: Column(
            children: [
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Icon(Octicons.request_changes),
                ),
                title: Text(
                  '무엇이든 만들어드립니다.',
                ),
                subtitle: Text('원하시는 기능이 있으면 요청해 주세요.'),
                trailing: Icon(Icons.keyboard_arrow_right_rounded, size: 32),
              )
            ],
          ),
        ),
      ),
    );
  }
}
