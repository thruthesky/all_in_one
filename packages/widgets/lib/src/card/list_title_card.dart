import 'package:flutter/material.dart';

/// It is a card style widget that work like [ListTile] material widget.
/// This widget gives more flexible options on leading sizes and margin, paddings.
class ListTileCard extends StatelessWidget {
  const ListTileCard(
      {required this.leading,
      required this.title,
      required this.content,
      this.spacing = 12,
      this.onTap,
      Key? key})
      : super(key: key);

  final Widget leading;
  final Widget title;
  final Widget content;
  final double spacing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
