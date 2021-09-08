import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class OneByOnePhotoInlineTextBottom extends StatelessWidget {
  const OneByOnePhotoInlineTextBottom({
    Key? key,
    this.categoryId,
    this.posts = const [],
    this.titlePadding = const EdgeInsets.all(4.0),
    this.photoHeight = 150,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = true,
    this.titleStyle = const TextStyle(color: Colors.white),
    this.textBGColor = const Color(0xaa000000),
    this.loaderBuilder,
    this.onItemTap,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;

  final EdgeInsets titlePadding;
  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle? titleStyle;
  final Color textBGColor;

  final Function? loaderBuilder;

  final Function(PostModel)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: PhotoInlineTextBottom(
              post: posts[0],
              centeredTitle: centeredTitle,
              photoHeight: photoHeight,
              photoWidth: photoWidth,
              thumbnailBorderRadius: thumbnailBorderRadius,
              titleStyle: titleStyle,
              textBGColor: textBGColor,
              titlePadding: titlePadding,
              onTap: onItemTap != null ? () => onItemTap!(posts[0]) : null,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: PhotoInlineTextBottom(
              post: posts[1],
              centeredTitle: centeredTitle,
              photoHeight: photoHeight,
              photoWidth: photoWidth,
              thumbnailBorderRadius: thumbnailBorderRadius,
              titleStyle: titleStyle,
              textBGColor: textBGColor,
              titlePadding: titlePadding,
              onTap: onItemTap != null ? () => onItemTap!(posts[1]) : null,
            ),
          ),
        ],
      ),
    );
  }
}
