import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// A box container with shadow
///
/// ```dart
/// ShadowBox(
///   margin: EdgeInsets.symmetric(horizontal: sm + 2),
///   padding: EdgeInsets.symmetric(horizontal: xs, vertical: sm),
///   child: Column( ... )
/// )
/// ```
class ShadowBox extends StatelessWidget {
  const ShadowBox({
    required this.child,
    this.padding,
    this.margin,
    this.color = const Color(0xFFEEEEEE),
    this.blurRadius = 5,
    this.spreadRadius = 2,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color color;
  final double blurRadius;
  final double spreadRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(sm),
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          )
        ],
      ),
      child: child,
    );
  }
}
