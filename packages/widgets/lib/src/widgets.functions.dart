import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 예제
/// ```dart
/// svg('face/devil')
/// svg(uviIcon(current.uvi), width: 20, height: 20)
/// ```
Widget svg(String path,
    {String package = 'widgets', double width = 32, double height = 32, Color? color}) {
  return SvgPicture.asset(
    "assets/svg/$path.svg",
    package: package,
    width: width,
    height: height,
    color: color,
  );
}
