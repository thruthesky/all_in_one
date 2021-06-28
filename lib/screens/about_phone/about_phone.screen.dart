import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:about_phone/about_phone.dart';
import 'package:widgets/widgets.dart';

class AboutPhoneScreen extends StatelessWidget {
  const AboutPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '핸드폰 정보',
      body: AboutPhoneDisplay(
        top: Column(
          children: [
            spaceLg,
            Icon(
              Icons.phonelink_setup_rounded,
              size: 64,
            ),
            spaceLg,
          ],
        ),
        title: '핸드폰 정보',
      ),
    );
  }
}
