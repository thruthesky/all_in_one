import 'package:flutter/material.dart';
import 'package:widgets/src/avatar/avatar.dart';
import 'package:x_flutter/x_flutter.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, this.size = 80.0, this.onTap}) : super(key: key);
  final double size;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: UserChange(
        loginBuilder: (user) => Avatar(
          url: user.hasPhoto ? user.photoUrl : Api.instance.anonymousIconUrl,
          size: size,
        ),
        logoutBuilder: (_) => Avatar(
          url: Api.instance.anonymousIconUrl,
          size: size,
        ),
      ),
    );
  }
}
