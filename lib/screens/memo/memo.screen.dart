import 'package:flutter/material.dart';
import '../../widgets/layout.dart';

class MemoScreen extends StatelessWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '메모장',
      body: Text('메모장'),
    );
  }
}
