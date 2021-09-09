import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class PhotoTextBottomList extends StatelessWidget {
  const PhotoTextBottomList({
    Key? key,
    this.categoryId,
    required this.posts,
    this.limit = 3,
    this.photoHeight = 200,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = true,
    this.titleStyle = const TextStyle(color: Colors.black),
    this.loaderBuilder,
    this.separatorBuilder,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;
  final int limit;

  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle? titleStyle;

  final Function? loaderBuilder;
  final Function? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, idx) {
        return separatorBuilder == null ? SizedBox(height: 8) : separatorBuilder!();
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        PostModel post = posts[index];
        return PhotoTextBottom(
          post: post,
          centeredTitle: centeredTitle,
          photoHeight: photoHeight,
          photoWidth: photoWidth,
          thumbnailBorderRadius: thumbnailBorderRadius,
          titleStyle: titleStyle,
        );
      },
    );
  }
}
