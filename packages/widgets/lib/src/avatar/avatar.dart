import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.avatarUrl, this.child}) : super(key: key);

  final String? avatarUrl;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl!),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.brown.shade800,
        child: child,
      );
    }
  }
}
