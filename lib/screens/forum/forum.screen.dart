import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:x_flutter/x_flutter.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(getArg('categoryId'));
    return Layout(
        title: '게시판',
        body: Container(
          child: Forum(
            categoryId: 'qna',
          ),
        ));
  }
}
