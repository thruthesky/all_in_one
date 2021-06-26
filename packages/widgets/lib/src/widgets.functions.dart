import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// [countryCode] is the alpha2 code.
Widget flag(String countryCode, {double width = 100, double? height, Color? color}) {
  return Image.asset(
    "assets/img/flags/$countryCode.png",
    package: 'widgets',
    width: width,
    height: height,
    color: color,
  );
}
