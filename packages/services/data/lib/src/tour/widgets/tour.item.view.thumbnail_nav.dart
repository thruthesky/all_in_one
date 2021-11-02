import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TourItemViewThumbnailNav extends StatefulWidget {
  const TourItemViewThumbnailNav(
    this.item,
    this.detail,
    this.onTap, {
    Key? key,
  }) : super(key: key);

  final TourApiListItem item;
  final TourApiListItem detail;
  final VoidCallback onTap;

  @override
  State<TourItemViewThumbnailNav> createState() => _TourItemViewThumbnailNavState();
}

class _TourItemViewThumbnailNavState extends State<TourItemViewThumbnailNav> {
  @override
  Widget build(BuildContext context) {
    if (widget.detail.images.length == 0) return SizedBox(height: sm);
    return Padding(
      padding: pageInset,
      child: Wrap(
          spacing: xxs,
          runSpacing: xxs,
          children: [for (final image in widget.detail.images) displayThumbnail(image)]),
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
          widget.item.firstimage = image.originimgurl;
          widget.onTap();
          setState(() {});
        },
      ),
    );

    if (widget.item.firstimage == image.originimgurl)
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
