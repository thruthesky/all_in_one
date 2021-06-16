import 'package:flutter/material.dart';
import 'package:widgets/src/avatar/avatar.dart';
import 'package:x_flutter/x_flutter.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: UserChange(
        loginBuilder: (user) => Avatar(
          avatarUrl: user.hasPhoto ? user.photoUrl : Api.instance.anonymousIconUrl,
        ),
        logoutBuilder: (_) => Avatar(
          avatarUrl: Api.instance.anonymousIconUrl,
        ),
      ),
    );
  }
}
