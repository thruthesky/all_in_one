import 'package:flutter/material.dart';
import 'package:widgets/src/avatar/avatar.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Avatar(
        child: Text(
          'Yo',
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
