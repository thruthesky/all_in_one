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
    this.onTap,
    this.maxTitleLines = 1,
    this.maxContentLines = 1,
    this.hero = false,
    this.loaderWidget,
    this.errorWidget,
    Key? key,
  }) : super(key: key);

  final PostModel post;
  final double thumbnailSize;
  final BorderRadius thumbnailBorderRadius;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  final Function? onTap;

  final int maxTitleLines;
  final int maxContentLines;

  final bool hero;

  final Widget? loaderWidget;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    Widget image = CacheImage(
      post.files.first.url,
      width: thumbnailSize,
      height: thumbnailSize,
      errorWidget: errorWidget,
      loaderWidget: loaderWidget,
    );
    if (hero) image = Hero(tag: post.files.first.url, child: image, transitionOnUserGestures: true);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap != null ? () => onTap!() : null,
      child: Container(
        child: Row(
          children: [
            ClipRRect(borderRadius: thumbnailBorderRadius, child: image),
            SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${post.idx} - ${post.title}',
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                    maxLines: maxTitleLines,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${post.content.replaceAll('\n', '')}",
                    overflow: TextOverflow.ellipsis,
                    style: contentStyle,
                    maxLines: maxContentLines,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
