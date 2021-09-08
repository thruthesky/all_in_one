import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class OneByOnePhotoTextBottom extends StatelessWidget {
  const OneByOnePhotoTextBottom({
    Key? key,
    this.categoryId,
    required this.posts,
    this.photoHeight = 150,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = false,
    this.titleStyle,
    this.loaderBuilder,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;

  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle? titleStyle;
  final Function? loaderBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: PhotoTextBottom(
              post: posts[0],
              centeredTitle: centeredTitle,
              photoHeight: photoHeight,
              photoWidth: photoWidth,
              thumbnailBorderRadius: thumbnailBorderRadius,
              titleStyle: titleStyle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: PhotoTextBottom(
              post: posts[1],
              centeredTitle: centeredTitle,
              photoHeight: photoHeight,
              photoWidth: photoWidth,
              thumbnailBorderRadius: thumbnailBorderRadius,
              titleStyle: titleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
