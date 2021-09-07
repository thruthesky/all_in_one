import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class PhotoTextBottomList extends StatelessWidget {
  const PhotoTextBottomList({
    Key? key,
    this.categoryId,
    this.posts = const [],
    this.limit = 3,
    this.photoHeight = 200,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = true,
    this.titleStyle = const TextStyle(color: Colors.black),
    this.loaderBuilder,
    this.separatorBuilder,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;
  final int limit;

  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle? titleStyle;

  final Function? loaderBuilder;
  final Function? separatorBuilder;

  Future<List<PostModel>> _fetchPosts() async {
    if (categoryId == null) return posts;
    return await PostApi.instance.search({
      'categoryId': categoryId,
      'files': "Y",
      'limit': limit,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchPosts(),
      builder: (context, AsyncSnapshot<List<PostModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (ctx, idx) {
              return separatorBuilder == null ? SizedBox(height: 8) : separatorBuilder!();
            },
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              PostModel post = snapshot.data![index];
              return PhotoTextBottom(
                    post: post,
                    centeredTitle: centeredTitle,
                    photoHeight: photoHeight,
                    photoWidth: photoWidth,
                    thumbnailBorderRadius: thumbnailBorderRadius,
                    titleStyle: titleStyle,
              );
            },
          );
        }
        return loaderBuilder != null ? loaderBuilder!() : SizedBox.shrink();
      },
    );
  }
}
