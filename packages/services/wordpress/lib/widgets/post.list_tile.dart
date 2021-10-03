import 'package:flutter/material.dart';
import 'package:wordpress/widgets/cache_image.dart';
import 'package:wordpress/wordpress.dart';

/// It is a card style widget copied from [ListTile] material widget.
/// This widget gives more flexible options on leading sizes and margin, paddings.
class PostListTile extends StatelessWidget {
  const PostListTile({
    required this.post,
    this.onTap,
    this.spacing = 12,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.imageWidth = 80.0,
    this.imageHeight = 80.0,
    Key? key,
  }) : super(key: key);

  final WPPost post;
  final VoidCallback? onTap;
  final double spacing;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double imageWidth;
  final double imageHeight;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: margin,
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CacheImage(
              post.featuredImageMediumThumbnailUrl,
              width: imageWidth,
              height: imageHeight,
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title),
                  Text(post.content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
