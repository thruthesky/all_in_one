import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton(this.icon, this.label, this.onTap, {Key? key}) : super(key: key);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            Icon(icon, size: 28),
            SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11))
          ],
        ),
      ),
    );
  }
}
