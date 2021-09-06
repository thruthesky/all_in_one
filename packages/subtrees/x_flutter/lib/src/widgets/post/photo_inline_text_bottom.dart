import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/src/widgets/cache_image.dart';

class PhotoInlineTextBottom extends StatelessWidget {
  const PhotoInlineTextBottom({
    required this.post,
    this.titlePadding = const EdgeInsets.all(4.0),
    this.photoHeight = 200,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = true,
    this.titleStyle = const TextStyle(color: Colors.white),
    this.textBGColor = const Color(0xaa000000),
    Key? key,
  }) : super(key: key);

  final PostModel post;
  final EdgeInsets titlePadding;
  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle? titleStyle;

  final Color textBGColor;

  @override
  Widget build(BuildContext context) {
    Widget title = Text('${post.idx} - ${post.title}', overflow: TextOverflow.ellipsis, style: titleStyle);
    if (centeredTitle) title = Center(child: title);

    title = Container(
      padding: titlePadding,
      color: textBGColor,
      child: title,
    );

    return Container(
      child: ClipRRect(
        borderRadius: thumbnailBorderRadius,
        child: Stack(children: [
          CacheImage(post.files.first.url, width: photoWidth, height: photoHeight),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: title,
          )
        ]),
      ),
    );
  }
}
