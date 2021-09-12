import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    this.text,
    this.child,
    this.color = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.margin = const EdgeInsets.all(6.0),
    this.padding = const EdgeInsets.all(6.0),
    this.radius = 3.0,
    this.onTap,
  }) : super(key: key);

  final String? text;
  final Widget? child;
  final Color color;
  final Color backgroundColor;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double radius;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: padding,
        padding: padding,
        decoration:
            BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(radius)),
        child: text != null
            ? Text(
                text!,
                style: TextStyle(color: color),
              )
            : (child != null ? child : SizedBox.shrink()),
      ),
      behavior: HitTestBehavior.opaque,
    );
  }
}
