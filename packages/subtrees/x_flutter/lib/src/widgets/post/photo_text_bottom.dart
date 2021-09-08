import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/src/widgets/cache_image.dart';

class PhotoTextBottom extends StatelessWidget {
  const PhotoTextBottom({
    required this.post,
    this.photoHeight = 200,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = false,
    this.titleStyle,
    this.maxTitleLine = 1,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final PostModel post;
  final double photoHeight;
  final double photoWidth;
  final thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle? titleStyle;
  final int maxTitleLine;

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!() : null,
      child: Container(
        child: Column(
          crossAxisAlignment: centeredTitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: thumbnailBorderRadius,
              child: CacheImage(post.files.first.url, width: photoWidth, height: photoHeight),
            ),
            SizedBox(height: 4),
            Text(
              '${post.idx} - ${post.title}',
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
              maxLines: maxTitleLine,
            )
          ],
        ),
      ),
    );
  }
}
