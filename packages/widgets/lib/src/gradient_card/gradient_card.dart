import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Image card
///
/// [titleStyle] is the TextStyle for title.
///
/// [titleAlign] can be any value of TextAline. Like TextAling.center.
/// [titleWidthFactor] can be 0 to 1 in double. 1 is the 100%.
/// [borderRadius] can be any double number. It's for the border radius.
///
/// [height] is needed to cover whole display area if there is constraints on parent widget.
///
/// ```dart
/// GradientCard(
///   title: post.title,
///   imageUrl: post.files.first.url,
///   borderRadius: 16,
///   onTap: () => service.openForumList('', arguments: {'postOnTop': post}),
///   height: double.infinity,
///   children: [Positioned(child: Text('Touch to enlarge'), top: 0, right: 10)],
/// );
/// ```
class GradientCard extends StatelessWidget {
  const GradientCard({
    required this.title,
    this.titleStyle = const TextStyle(color: Colors.white),
    required this.imageUrl,
    this.onTap,
    this.borderRadius = 0.0,
    this.imageLoader = const SizedBox.shrink(),
    this.imageErrorWidget = const Icon(Icons.error),
    Key? key,
    this.titleWidthFactor = 0.7,
    this.titleAlign = TextAlign.center,
    this.width = double.infinity,
    this.height,
    this.hero = true,
    this.children,
  }) : super(key: key);

  final String title;
  final titleStyle;
  final String imageUrl;
  final VoidCallback? onTap;
  final double borderRadius;
  final Widget imageLoader;
  final Widget imageErrorWidget;
  final double titleWidthFactor;
  final double width;
  final double? height;
  final TextAlign titleAlign;
  final bool hero;
  final List<Positioned>? children;

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      width: width,
      height: height,
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      placeholder: (ctx, url) => imageLoader,
      errorWidget: (context, url, error) => imageErrorWidget,
    );

    if (hero) image = Hero(tag: imageUrl, child: image);

    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Container(child: image),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: FractionallySizedBox(
                  widthFactor: titleWidthFactor,
                  child: Text(
                    title,
                    maxLines: 1,
                    textAlign: titleAlign,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                ),
              ),
              left: 0,
              right: 0,
              bottom: 0,
            ),
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
