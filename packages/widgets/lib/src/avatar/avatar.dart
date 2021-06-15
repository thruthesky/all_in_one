import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.avatarUrl, this.child}) : super(key: key);

  final String? avatarUrl;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipOval(
          child: CachedNetworkImage(
        imageUrl: "http://via.placeholder.com/350x150",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      )),
      constraints: BoxConstraints(minWidth: 80, minHeight: 80, maxWidth: 80, maxHeight: 80),
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
