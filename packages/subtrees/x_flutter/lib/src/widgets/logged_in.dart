import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class LoggedIn extends StatelessWidget {
  const LoggedIn({Key? key, required this.builder, this.onTap}) : super(key: key);

  final VoidCallback? onTap;
  final Function builder;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: UserChange(
        loginBuilder: builder,
        logoutBuilder: (_) => SizedBox.shrink(),
      ),
    );
  }
}
