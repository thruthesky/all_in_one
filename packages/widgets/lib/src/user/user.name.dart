import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class UserName extends StatelessWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: UserChange(
        loginBuilder: (user) => Text(user.name),
        logoutBuilder: (_) => Text('...'),
      ),
    );
  }
}
