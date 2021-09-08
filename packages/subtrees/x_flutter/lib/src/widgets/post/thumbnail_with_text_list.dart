import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/x_flutter.dart';

class ThumbnailWithTextList extends StatelessWidget {
  const ThumbnailWithTextList({
    this.categoryId,
    required this.posts,
    this.limit = 3,
    this.thumbnailSize = 60.0,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.titleStyle,
    this.contentStyle,
    this.loaderBuilder,
    this.separatorBuilder,
    this.onItemTap,
    this.maxTitleLines = 1,
    this.maxContentLines = 2,
    Key? key,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;

  final int limit;

  final double thumbnailSize;
  final BorderRadius thumbnailBorderRadius;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Function? loaderBuilder;
  final Function? separatorBuilder;

  final Function(PostModel)? onItemTap;

  final int maxTitleLines;
  final int maxContentLines;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, idx) {
        return separatorBuilder == null ? SizedBox(height: 4) : separatorBuilder!();
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        PostModel post = posts[index];
        return ThumbnailWithText(
          post: post,
          thumbnailSize: thumbnailSize,
          thumbnailBorderRadius: thumbnailBorderRadius,
          titleStyle: titleStyle,
          contentStyle: contentStyle,
          onTap: onItemTap != null ? () => onItemTap!(post) : null,
          maxTitleLines: maxTitleLines,
          maxContentLines: maxContentLines,
        );
      },
    );
  }
}
