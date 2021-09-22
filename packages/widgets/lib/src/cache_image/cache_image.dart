import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../spinner/spinner.dart';

/// 이미지를 캐시해서 보기
///
/// 사진을 화면에 가득 채워 나타내려면, `width: double.infinity, height: null` 로 입력하면 된다.
/// 참고, x_flutter 의 것은 외부에서 사용 불가. 대신, widgets 패키지의 것을 사용.
class CacheImage extends StatelessWidget {
  CacheImage(
    this.url, {
    this.width = double.infinity,
    this.height,
    this.onLoadComplete,
    this.fit = BoxFit.cover,
  });
  final String url;
  final double width;
  final double? height;
  final Function? onLoadComplete;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    if (url == '') {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(
          Icons.error,
          size: 64,
        ),
      );
    }
    return CachedNetworkImage(
      imageBuilder: (context, provider) {
        // execute your onLoad code here
        // print("Image has been loaded!");
        if (onLoadComplete != null) Timer(Duration(milliseconds: 100), () => onLoadComplete!());
        // Return the image that has built by hand.
        return Image(image: provider, fit: fit);
      },
      imageUrl: url,
      placeholder: (context, url) => Spinner(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: width,
      height: height,
    );
  }
}

/// CacheImage 를 Tap 할 수 있도록 해 주는 Wrapper 이다.
class CacheImageTap extends StatelessWidget {
  const CacheImageTap(this.url,
      {this.width = double.infinity,
      this.height,
      this.onLoadComplete,
      this.fit = BoxFit.cover,
      required this.onTap,
      Key? key})
      : super(key: key);

  final String url;
  final double width;
  final double? height;
  final Function? onLoadComplete;
  final BoxFit fit;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CacheImage(
        this.url,
        width: width,
        height: height,
        onLoadComplete: onLoadComplete,
        fit: fit,
      ),
    );
  }
}
