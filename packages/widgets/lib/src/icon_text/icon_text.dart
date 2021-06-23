import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.icon,
    required this.size,
    required this.label,
  }) : super(key: key);

  final IconData icon;
  final double size;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(icon, size: size),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: size / 2 - 5))
        ],
      ),
    );
  }
}
