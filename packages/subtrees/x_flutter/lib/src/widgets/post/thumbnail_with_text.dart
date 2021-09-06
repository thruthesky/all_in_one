import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/src/widgets/cache_image.dart';

class ThumbnailWithText extends StatelessWidget {
  const ThumbnailWithText({
    required this.post,
    this.thumbnailSize = 50.0,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.titleStyle,
    this.contentStyle,
    Key? key,
  }) : super(key: key);

  final PostModel post;
  final double thumbnailSize;
  final BorderRadius thumbnailBorderRadius;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: thumbnailBorderRadius,
            child: CacheImage(post.files.first.url, width: thumbnailSize, height: thumbnailSize),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${post.title}", overflow: TextOverflow.ellipsis, style: titleStyle),
                SizedBox(height: 8),
                Text("${post.content.replaceAll('\n', '')}", overflow: TextOverflow.ellipsis, style: contentStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
