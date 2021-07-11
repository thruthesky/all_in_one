import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
        title: '연락처',
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('개발자 연락처입니다.'),
                Text('송재호: thruthesky@gmail.com'),
                spaceXl,
                Text('기능 요청'),
                Divider(),
                Text('원하시는 기능이 있으면 만들어드립니다.'),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('기능 요청하기'),
                ),
              ],
            ),
          ),
        ));
  }
}
