import 'package:flutter/material.dart';

class TextTap extends StatelessWidget {
  const TextTap(
    this.text, {
    required this.onTap,
    this.style,
    this.top = 0,
    this.left = 0,
    this.right = 0,
    this.bottom = 0,
    this.textAlign,
    Key? key,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final VoidCallback onTap;
  final double top;
  final double left;
  final double right;
  final double bottom;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
        child: Text(
          text,
          style: style,
          textAlign: textAlign,
        ),
      ),
      onTap: onTap,
    );
  }
}
