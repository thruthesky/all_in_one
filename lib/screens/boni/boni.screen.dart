import 'package:flutter/material.dart';

class BoniScreen extends StatelessWidget {
  const BoniScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('boni'),
      ),
      body: Text('Hello boni!!'),
    );
  }
}
