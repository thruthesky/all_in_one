import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wordpress/wordpress.dart';
import './user.change.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, this.size = 80.0, this.iconSize, this.onTap}) : super(key: key);
  final double size;
  final double? iconSize;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: UserChange(
        loginBuilder: (WPUser user) => user.hasPhoto
            ? _Avatar(
                url: user.photoUrl,
                size: size,
              )
            : Icon(
                Icons.account_circle_rounded,
                size: iconSize ?? size,
                color: Colors.black87,
              ),
        logoutBuilder: (_) => Icon(
          Icons.account_circle_rounded,
          size: iconSize ?? size,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({Key? key, required this.url, this.size = 80.0}) : super(key: key);

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    late Widget image;
    if (url.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => CircularProgressIndicator.adaptive(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      );
    }
    return Container(
      child: ClipOval(
        child: image,
      ),
      constraints: BoxConstraints(minWidth: size, minHeight: size, maxWidth: size, maxHeight: size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.white, blurRadius: 1.0, spreadRadius: 1.0),
        ],
      ),
    );
  }
}
