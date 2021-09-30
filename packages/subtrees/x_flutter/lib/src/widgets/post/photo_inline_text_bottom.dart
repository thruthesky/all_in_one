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
    this.onTap,
    this.hero = true,
    this.errorWidget,
    this.loaderWidget,
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

  final Function? onTap;

  final bool hero;

  final Widget? errorWidget;
  final Widget? loaderWidget;

  @override
  Widget build(BuildContext context) {
    Widget title = Text('${post.title}', overflow: TextOverflow.ellipsis, style: titleStyle);
    Widget image = CacheImage(
      post.files.first.url,
      width: photoWidth,
      height: photoHeight,
      loaderWidget: loaderWidget,
      errorWidget: errorWidget,
    );
    if (centeredTitle) title = Center(child: title);

    title = Container(
      padding: titlePadding,
      color: textBGColor,
      child: title,
    );

    if (hero) image = Hero(tag: post.files.first.url, child: image, transitionOnUserGestures: true);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap != null ? () => onTap!() : null,
      child: Container(
        child: ClipRRect(
          borderRadius: thumbnailBorderRadius,
          child: Stack(children: [
            image,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: title,
            )
          ]),
        ),
      ),
    );
  }
}
