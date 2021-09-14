import 'package:flutter/material.dart';

/// Text Chip with tap action.
///
/// Customizable properties are;
/// [fontSize], [color], [backgroundColor], [borderRadius], [padding], [onTap]
class TextChip extends StatelessWidget {
  const TextChip(
    this.text, {
    this.fontSize = 12.0,
    this.color = Colors.black,
    this.backgroundColor = Colors.black12,
    this.borderRadius = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final Color color;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(),
      child: Container(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
