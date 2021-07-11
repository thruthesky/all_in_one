import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

/// 왼쪽, 오른쪽 두개의 위젯을 받아서, 중앙 정렬.
///
/// 여러 행에 정보를 나열 할 때, 중앙 정렬을 하고자 할 때 사용하면 된다.
///
class CenteredRow extends StatelessWidget {
  const CenteredRow({Key? key, required this.left, required this.right}) : super(key: key);
  final Widget left;
  final Widget right;
  @override
  Widget build(BuildContext context) {
    return ResponsiveGridRow(children: [
      ResponsiveGridCol(
          xs: 6,
          child: Container(
            alignment: Alignment.centerRight,
            child: left,
          )),
      ResponsiveGridCol(xs: 6, child: right),
    ]);
  }
}
