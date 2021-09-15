import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  const GradientCard({
    required this.title,
    required this.imageUrl,
    this.onTap,
    this.borderRadius = 0.0,
    this.imageLoader = const SizedBox.shrink(),
    this.imageErrorWidget = const Icon(Icons.error),
    Key? key,
  }) : super(key: key);

  final String title;
  final String imageUrl;
  final VoidCallback? onTap;
  final double borderRadius;
  final Widget imageLoader;
  final Widget imageErrorWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Container(
              child: Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: imageUrl,
                  placeholder: (ctx, url) => imageLoader,
                  errorWidget: (context, url, error) => imageErrorWidget,
                ),
              ),
            ),
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
                child: Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
                ),
              ),
              left: 0,
              right: 0,
              bottom: 0,
            ),
          ],
        ),
      ),
    );
  }
}
