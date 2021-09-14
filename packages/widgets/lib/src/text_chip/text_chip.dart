import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// Text Chip with tap action.
class TextChip extends StatelessWidget {
  const TextChip(
    this.text, {
    this.fontSize = 12.0,
    this.color = Colors.black,
    this.backgroundColor = Colors.black12,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: xxs + 2, vertical: xxs),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(xxs),
        ),
      ),
    );
  }
}
