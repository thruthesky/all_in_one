import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class MyName extends StatelessWidget {
  const MyName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Text('My name is: ${UserApi.instance.name}'),
    );
  }
}
