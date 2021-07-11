import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    this.text,
    this.color = Colors.white,
    this.backgroundColor = Colors.black87,
    this.margin = const EdgeInsets.all(6.0),
    this.padding = const EdgeInsets.all(6.0),
    this.radius = 3.0,
    this.onTap,
  }) : super(key: key);

  final String? text;
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
        child: Row(
          children: [
            if (text != null)
              Text(
                text!,
                style: TextStyle(color: color),
              ),
          ],
        ),
      ),
    );
  }
}
