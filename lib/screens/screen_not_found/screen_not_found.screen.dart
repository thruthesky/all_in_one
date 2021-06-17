import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class ScreenNotFoundScreen extends StatelessWidget {
  const ScreenNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '화면 없음',
      body: Text('현재 경로에 대한 스크린을 찾지 못하였습니다.'),
    );
  }
}
