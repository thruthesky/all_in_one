import 'package:flutter/material.dart';

class ShadowedContainer extends StatelessWidget {
  const ShadowedContainer({
    required this.child,
    this.shadowColor = Colors.grey,
    this.elevation = 4,
    this.borderRadius = 15,
    this.padding = const EdgeInsets.all(0),
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  final Widget child;

  final Color shadowColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shadowColor: shadowColor,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        child: child,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}
