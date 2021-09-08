import 'package:flutter/material.dart';
import 'package:x_flutter/src/models/post.model.dart';
import 'package:x_flutter/x_flutter.dart';

typedef PostModelCallBack = void Function(PostModel post);

class PostTitleList extends StatelessWidget {
  const PostTitleList({
    this.categoryId,
    required this.posts,
    this.limit = 3,
    this.titleStyle,
    this.loaderBuilder,
    this.separatorBuilder,
    this.onTap,
    this.maxTitleLines = 1,
    this.showUser = false,
    Key? key,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;

  final int limit;

  final TextStyle? titleStyle;
  final Function? loaderBuilder;
  final Function? separatorBuilder;
  final PostModelCallBack? onTap;

  final int maxTitleLines;
  final bool showUser;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, idx) {
        return separatorBuilder == null ? SizedBox(height: 4) : separatorBuilder!();
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        PostModel post = posts[index];

        if (post.deleted) return SizedBox.shrink(); 

        Widget widget = Text('${post.idx} - ${post.title}',
            overflow: TextOverflow.ellipsis, style: titleStyle, maxLines: maxTitleLines);

        if (showUser)
          widget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget,
              SizedBox(height: 4),
              Text('by ${post.user.displayName}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
            ],
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
}
