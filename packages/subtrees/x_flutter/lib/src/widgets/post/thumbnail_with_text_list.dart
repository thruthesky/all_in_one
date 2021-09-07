import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/src/post.api.dart';
import 'package:x_flutter/x_flutter.dart';

class ThumbnailWithTextList extends StatelessWidget {
  const ThumbnailWithTextList({
    this.categoryId,
    this.posts = const [],
    this.limit = 3,
    this.thumbnailSize = 50.0,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.titleStyle,
    this.contentStyle,
    this.loaderBuilder,
    this.separatorBuilder,
    Key? key,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;

  final int limit;

  final double thumbnailSize;
  final BorderRadius thumbnailBorderRadius;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Function? loaderBuilder;
  final Function? separatorBuilder;

  Future<List<PostModel>> _fetchPosts() async {
    if (categoryId == null) return posts;
    return await PostApi.instance.search({
      'categoryId': categoryId,
      'limit': limit,
      'files': 'Y',
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<PostModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (ctx, idx) {
              return separatorBuilder == null ? SizedBox(height: 4) : separatorBuilder!();
            },
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              PostModel post = snapshot.data![index];
              return ThumbnailWithText(
                post: post,
                thumbnailSize: thumbnailSize,
                thumbnailBorderRadius: thumbnailBorderRadius,
                titleStyle: titleStyle,
                contentStyle: contentStyle,
              );
            },
          );
        }
        return loaderBuilder != null ? loaderBuilder!() : SizedBox.shrink();
      },
      future: _fetchPosts(),
    );
  }
}
