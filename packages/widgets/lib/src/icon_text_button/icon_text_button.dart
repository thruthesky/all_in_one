import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton(this.icon, this.label, this.onTap, {Key? key, this.size = 28})
      : super(key: key);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: IconText(icon: icon, size: size, label: label),
    );
  }
}
