import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/src/widgets/cache_image.dart';

class PhotoTextUserMeta extends StatelessWidget {
  const PhotoTextUserMeta({
    required this.post,
    this.photoHeight = 200,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = false,
    this.categoryStyle = const TextStyle(color: Colors.indigo, fontSize: 18),
    this.titleStyle,
    Key? key,
  }) : super(key: key);

  final PostModel post;
  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle categoryStyle;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: thumbnailBorderRadius,
            child: CacheImage(post.files.first.url, width: photoWidth, height: photoHeight),
          ),
          SizedBox(height: 8),
          Text('${post.categoryId}', style: categoryStyle),
          SizedBox(height: 4),
          Text('${post.idx} - ${post.title}', overflow: TextOverflow.ellipsis, style: titleStyle),
          SizedBox(height: 4),
          Text('${post.user.displayName} ∙ ${post.shortDate}', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
