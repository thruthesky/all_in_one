// import 'package:flutter/material.dart';
// import 'package:widgets/src/avatar/avatar.dart';
// import 'package:x_flutter/x_flutter.dart';

// /// Do NOT use this.
// /// This is depending on a package when it should NOT be.
// class UserAvatar extends StatelessWidget {
//   const UserAvatar({Key? key, this.size = 80.0, this.onTap}) : super(key: key);
//   final double size;
//   final VoidCallback? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: UserChange(
//         loginBuilder: (UserModel user) => Avatar(
//           url: user.photoUrl != '' ? user.photoUrl : Api.instance.anonymousIconUrl,
//           size: size,
//         ),
//         logoutBuilder: (_) => Avatar(
//           url: Api.instance.anonymousIconUrl,
//           size: size,
//         ),
//       ),
//     );
//   }
// }
