import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/src/widgets/cache_image.dart';

class PhotoTextUserMeta extends StatelessWidget {
  const PhotoTextUserMeta({
    required this.post,
    this.photoHeight = 150,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = false,
    this.categoryStyle = const TextStyle(color: Colors.indigo, fontSize: 18),
    this.titleStyle,
    this.contentStyle,
    this.showCategory = false,
    this.showContent = false,
    this.maxTitleLine = 1,
    this.maxContentLine = 3,
    this.onTap,
    this.hero = false,
    Key? key,
  }) : super(key: key);

  final PostModel post;
  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle categoryStyle;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final bool showCategory;
  final bool showContent;
  final int maxTitleLine;
  final int maxContentLine;
  final Function? onTap;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    Widget image = CacheImage(post.files.first.url, width: photoWidth, height: photoHeight);

    if (hero) image = Hero(tag: post.files.first.url, child: image);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap != null ? () => onTap!() : null,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: thumbnailBorderRadius, child: image),
          SizedBox(height: 8),
          if (showCategory) ...[
            Text('${post.categoryId}', style: categoryStyle),
            SizedBox(height: 4),
          ],
          Text(
            '${post.idx} - ${post.title}',
            overflow: TextOverflow.ellipsis,
            maxLines: maxTitleLine,
            style: titleStyle,
          ),
          SizedBox(height: 4),
          if (showContent) ...[
            Text(
              '${post.content}',
              maxLines: maxContentLine,
              style: contentStyle,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
          ],
          Text('${post.user.displayName} ∙ ${post.shortDate}',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
