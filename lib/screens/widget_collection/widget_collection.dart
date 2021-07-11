import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WidgetCollectionScreen extends StatelessWidget {
  const WidgetCollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '재 사용 가능한 위젯 모음',
      body: WidgetCollection(),
    );
  }
}
