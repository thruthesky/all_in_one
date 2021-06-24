import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
/// 참고, x_flutter 의 것은 외부에서 사용 불가. 대신, widgets 패키지의 것을 사용.
class Spinner extends StatelessWidget {
  const Spinner({
    Key? key,
    this.size = 24,
    this.loading = true,
    this.centered = true,
    this.valueColor = Colors.yellow,
    this.padding,
  }) : super(key: key);

  final double size;
  final bool loading;
  final bool centered;
  final Color valueColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (loading == false) return SizedBox.shrink();
    Widget spinner = SizedBox(
      width: size,
      height: size,
      child: Platform.isAndroid
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(valueColor),
            )
          : CupertinoActivityIndicator(),
    );

    if (padding != null) {
      spinner = Padding(padding: padding!, child: spinner);
    }

    return centered ? Center(child: spinner) : spinner;
  }
}
