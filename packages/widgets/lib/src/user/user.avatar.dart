import 'package:flutter/material.dart';
import 'package:widgets/src/avatar/avatar.dart';
import 'package:x_flutter/x_flutter.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, this.size = 80.0}) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return UserChange(
      loginBuilder: (user) => Avatar(
        avatarUrl: user.hasPhoto ? user.photoUrl : Api.instance.anonymousIconUrl,
        size: size,
      ),
      logoutBuilder: (_) => Avatar(
        avatarUrl: Api.instance.anonymousIconUrl,
        size: size,
      ),
    );
  }
}
