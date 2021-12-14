import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

@Deprecated('Use TourItemViewThumbnailNav')
class TourViewThumbnailNav extends StatelessWidget {
  TourViewThumbnailNav(
    this.index, {
    Key? key,
  }) : super(key: key);
  final int index;

  final TourController _ = TourController.of;

  @override
  Widget build(BuildContext context) {
    if (_.detail.images.length == 0) return SizedBox(height: sm);
    return Padding(
      padding: pageInset,
      child: Wrap(
          spacing: xxs,
          runSpacing: xxs,
          children: [for (final image in _.detail.images) displayThumbnail(image)]),
    );
  }

  displayThumbnail(TourImage image) {
    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(xs),
      child: CacheImageTap(
        image.originimgurl,
        width: 60,
        height: 60,
        onTap: () {
          _.items[index].firstimage = image.originimgurl;
          _.update();
        },
      ),
    );

    if (_.items[index].firstimage == image.originimgurl)
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red[700]!, width: 1),
          borderRadius: BorderRadius.circular(xs),
        ),
        child: child,
      );
    else
      return child;
  }
}
