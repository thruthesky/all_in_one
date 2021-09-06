import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class OneByOnePhotoTextBottom extends StatelessWidget {
  const OneByOnePhotoTextBottom({
    Key? key,
    this.categoryId,
    this.posts = const [],
    this.photoHeight = 150,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = false,
    this.titleStyle,
    this.loaderBuilder,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;

  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle? titleStyle;
  final Function? loaderBuilder;

  Future<List<PostModel>> _fetchPosts() async {
    if (categoryId == null) return posts;
    return await PostApi.instance.search({
      'categoryId': categoryId,
      'files': "Y",
      'limit': 2,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchPosts(),
      builder: (context, AsyncSnapshot<List<PostModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Container(
            child: Row(
              children: [
                Expanded(
                  child: PhotoTextBottom(
                    post: snapshot.data![0],
                    centeredTitle: centeredTitle,
                    photoHeight: photoHeight,
                    photoWidth: photoWidth,
                    thumbnailBorderRadius: thumbnailBorderRadius,
                    titleStyle: titleStyle,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: PhotoTextBottom(
                    post: snapshot.data![1],
                    centeredTitle: centeredTitle,
                    photoHeight: photoHeight,
                    photoWidth: photoWidth,
                    thumbnailBorderRadius: thumbnailBorderRadius,
                    titleStyle: titleStyle,
                  ),
                ),
              ],
            ),
          );
        }
        return loaderBuilder != null ? loaderBuilder!() : SizedBox.shrink();
      },
    );
  }
}
