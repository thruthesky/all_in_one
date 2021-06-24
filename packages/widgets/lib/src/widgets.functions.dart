import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svg(String path, [String package = 'widgets']) {
  return SvgPicture.asset(
    "assets/svg/$path.svg",
    package: package,
  );
}
