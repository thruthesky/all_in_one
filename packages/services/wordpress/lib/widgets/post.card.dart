import 'package:flutter/material.dart';
import 'package:wordpress/widgets/cache_image.dart';
import 'package:wordpress/wordpress.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.onTap,
    Key? key,
    this.hero = false,
  }) : super(key: key);

  final WPPost post;
  final VoidCallback onTap;
  final bool hero;
  @override
  Widget build(BuildContext context) {
    print('large; ${post.featuredImageLargeThumbnailUrl}');
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title),
            wrapHero(CacheImage(
              post.featuredImageLargeThumbnailUrl,
              width: double.infinity,
              height: 200,
            )),
            Text(post.content),
          ],
        ),
      ),
    );
  }

  wrapHero(widget) {
    if (hero)
      return Hero(tag: post.files.first.url, child: widget, transitionOnUserGestures: true);
    else
      return widget;
  }
}
