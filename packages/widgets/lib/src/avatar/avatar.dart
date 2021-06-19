import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.url, this.size = 80.0}) : super(key: key);

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    late Widget image;
    String _url = url;
    if (_url == '') {
      _url = Api.instance.anonymousIconUrl;
    }
    if (_url.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: _url,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      );
    } else {
      image = Image.asset(_url);
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
