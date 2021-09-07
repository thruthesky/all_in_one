import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class OneByOnePhotoInlineTextBottom extends StatelessWidget {
  const OneByOnePhotoInlineTextBottom({
    Key? key,
    this.categoryId,
    this.posts = const [],
    this.titlePadding = const EdgeInsets.all(4.0),
    this.photoHeight = 150,
    this.photoWidth = double.infinity,
    this.thumbnailBorderRadius = BorderRadius.zero,
    this.centeredTitle = true,
    this.titleStyle = const TextStyle(color: Colors.white),
    this.textBGColor = const Color(0xaa000000),
    this.loaderBuilder,
  }) : super(key: key);

  final String? categoryId;
  final List<PostModel> posts;

  final EdgeInsets titlePadding;
  final double photoHeight;
  final double photoWidth;
  final BorderRadius thumbnailBorderRadius;
  final bool centeredTitle;
  final TextStyle? titleStyle;
  final Color textBGColor;

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
                  child: PhotoInlineTextBottom(
                    post: snapshot.data![0],
                    centeredTitle: centeredTitle,
                    photoHeight: photoHeight,
                    photoWidth: photoWidth,
                    thumbnailBorderRadius: thumbnailBorderRadius,
                    titleStyle: titleStyle,
                    textBGColor: textBGColor,
                    titlePadding: titlePadding,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child:PhotoInlineTextBottom(
                    post: snapshot.data![1],
                    centeredTitle: centeredTitle,
                    photoHeight: photoHeight,
                    photoWidth: photoWidth,
                    thumbnailBorderRadius: thumbnailBorderRadius,
                    titleStyle: titleStyle,
                    textBGColor: textBGColor,
                    titlePadding: titlePadding,
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
