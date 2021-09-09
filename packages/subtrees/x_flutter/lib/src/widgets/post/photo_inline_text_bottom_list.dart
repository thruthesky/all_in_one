import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class PhotoInlineTextBottomList extends StatelessWidget {
  const PhotoInlineTextBottomList({
    Key? key,
    this.categoryId,
    required this.posts,
    this.titlePadding = const EdgeInsets.all(4.0),
    this.photoHeight = 150,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = true,
    this.titleStyle = const TextStyle(color: Colors.white),
    this.textBGColor = const Color(0xaa000000),
    this.loaderBuilder,
    this.separatorBuilder,
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
  final Function? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final PostModel post = posts[index];
        return PhotoInlineTextBottom(
          post: post,
          centeredTitle: centeredTitle,
          photoHeight: photoHeight,
          photoWidth: photoWidth,
          thumbnailBorderRadius: thumbnailBorderRadius,
          titleStyle: titleStyle,
          textBGColor: textBGColor,
          titlePadding: titlePadding,
        );
      },
      separatorBuilder: (context, index) {
        return separatorBuilder != null ? separatorBuilder!() : SizedBox(height: 8);
      },
      itemCount: posts.length,
    );
  }
}
