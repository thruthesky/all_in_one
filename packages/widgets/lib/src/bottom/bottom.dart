import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  const Bottom(this.child, this.bottom, {Key? key}) : super(key: key);
  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: bottom),
      child: child,
    );
  }
}
