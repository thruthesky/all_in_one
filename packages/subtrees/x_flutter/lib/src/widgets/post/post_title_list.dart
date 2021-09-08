import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/src/post.api.dart';
import 'package:x_flutter/x_flutter.dart';

typedef PostModelCallBack = void Function(PostModel post);

class PostTitleList extends StatelessWidget {
  const PostTitleList({
    this.categoryId,
    this.posts = const [],
    this.limit = 3,
    this.titleStyle,
    this.loaderBuilder,
    this.separatorBuilder,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;

  final int limit;

  final TextStyle? titleStyle;
  final Function? loaderBuilder;
  final Function? separatorBuilder;
  final PostModelCallBack? onTap;

  Future<List<PostModel>> _fetchPosts() async {
    if (categoryId == null) return posts;
    return await PostApi.instance.search({
      'categoryId': categoryId,
      'limit': limit,
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

              Widget widget = Text(
                '${post.idx} - ${post.title}',
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              );

              if (onTap != null) {
                widget = GestureDetector(
                  child: widget,
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap != null ? () => onTap!(post) : null,
                );
              }
              return widget;
            },
          );
        }
        return loaderBuilder != null ? loaderBuilder!() : SizedBox.shrink();
      },
      future: _fetchPosts(),
    );
  }
}
