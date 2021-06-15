import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class BoniScreen extends StatelessWidget {
  const BoniScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'boni',
      body: Text('Hello boni!!'),
    );
  }
}
