import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.url, this.size = 80.0}) : super(key: key);

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    late Widget child;
    if (url.startsWith('http')) {
      child = CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      );
    } else {
      child = Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Icon(
          Icons.person_rounded,
          color: Colors.grey[700],
        ),
      );
    }
    return Container(
      child: ClipOval(
        child: child,
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
