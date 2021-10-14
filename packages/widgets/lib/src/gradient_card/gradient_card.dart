import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// Image card
///
/// [titleStyle] is the TextStyle for title.
///
/// [titleAlign] can be any value of TextAline. Like TextAling.center.
/// [titleWidthFactor] can be 0 to 1 in double. 1 is the 100%.
/// [borderRadius] can be any double number. It's for the border radius.
/// [imageUrl] is the background image.
/// [fit] is the BoxFit for background imgae.
/// [height] is needed to make the card background image to desired size.
///   - It can be null with 'fit: BoxFit.cover' for natural look.
///   - If you want to cover the card with the image, then width, height must be given.
///     Both of width & height can be [double.inifity] to fit the card size.
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
///
/// ```dart
/// GradientCard(
///   imageUrl: item.firstimage,
///   height: double.infinity,
///   title: item.englishTitle,
///   onTap: () => TourController.to.view(index),
///   borderRadius: 10,
///   imageLoader: Shimmer.fromColors(
///     baseColor: Colors.grey.shade50,
///     highlightColor: Colors.grey.shade200,
///     child: Container(
///     // height: index % 2 == 0 ? 125 : 100,
///       width: double.infinity,
///       decoration: BoxDecoration(
///         color: Colors.grey.shade50,
///         borderRadius: BorderRadius.circular(10),
///       ),
///     ),
///   ),
///   imageErrorWidget: Container(
///     height: index % 2 == 0 ? 125 : 100,
///     child: Center(
///       child: Icon(Icons.image_not_supported_outlined),
///     ),
///   ),
/// );
/// ```
class GradientCard extends StatelessWidget {
  const GradientCard({
    required this.title,
    this.titleStyle = const TextStyle(color: Colors.white),
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.onTap,
    this.borderRadius = 0.0,
    Key? key,
    this.titleWidthFactor = 0.7,
    this.titleAlign = TextAlign.center,
    this.width = double.infinity,
    this.height,
    this.heroTag,
    this.children,
  }) : super(key: key);

  final String title;
  final titleStyle;
  final String imageUrl;
  final VoidCallback? onTap;
  final double borderRadius;
  final double titleWidthFactor;
  final double width;
  final double? height;
  final TextAlign titleAlign;
  final String? heroTag;
  final List<Positioned>? children;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    Widget image = CacheImage(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      heroTag: heroTag,
    );

    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            image,
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
