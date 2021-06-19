import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.avatarUrl, this.size = 80.0}) : super(key: key);

  final String avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    late Widget image;
    if (avatarUrl.startsWith('http'))
      image = CachedNetworkImage(
        imageUrl: avatarUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      );
    else
      image = Image.asset(avatarUrl);
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
