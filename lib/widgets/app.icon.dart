import '../services/globals.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    this.icon,
    this.label = '',
    this.action,
    Key? key,
    this.arguments,
    this.child,
  }) : super(key: key);
  final IconData? icon;
  final Widget? child;
  final String label;

  final dynamic action;
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return IconTextButton(icon!, label, () {
        if (action is String)
          service.open(action, arguments: arguments);
        else
          action();
      }, size: 40);
    } else {
      return GestureDetector(
        child: Column(
          children: [
            SizedBox(height: 2),
            child!,
            spaceXs,
            Text(
              label,
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (action is String)
            service.open(action, arguments: arguments);
          else
            action();
        },
      );
    }
  }
}
