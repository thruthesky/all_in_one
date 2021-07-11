import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class UserName extends StatelessWidget {
  const UserName({
    Key? key,
    this.prefixLogin = '',
    this.suffixLogin = '',
    this.defaultName = '...',
    this.style,
    this.onTap,
  }) : super(key: key);
  final String prefixLogin;
  final String suffixLogin;
  final String defaultName;

  final TextStyle? style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: UserChange(
          loginBuilder: (UserModel user) => Text(
            prefixLogin + user.name + suffixLogin,
            style: style,
          ),
          logoutBuilder: (_) => Text(
            defaultName,
            style: style,
          ),
        ),
      ),
    );
  }
}
