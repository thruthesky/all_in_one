import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class UserName extends StatelessWidget {
  const UserName({Key? key, this.defaultName = '...', this.onTap}) : super(key: key);
  final String defaultName;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: UserChange(
          loginBuilder: (UserModel user) => Text(user.name),
          logoutBuilder: (_) => Text(defaultName),
        ),
      ),
    );
  }
}
