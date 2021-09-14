import 'package:flutter/material.dart';

/// Give padding vertically and horizontally.
class PagePadding extends StatelessWidget {
  const PagePadding({
    this.horizontal = 8.0,
    this.vertical = 0.0,
    required this.children,
    Key? key,
  }) : super(key: key);

  final double horizontal;
  final double vertical;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
