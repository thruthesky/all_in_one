import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';

class TourCard extends StatelessWidget {
  const TourCard({Key? key, required this.item, required this.index}) : super(key: key);

  final TourApiListItem item;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: index % 2 == 0 ? Colors.grey : Colors.amber,
        child: Column(
          children: [
            if (item.firstimage2 == null)
              Icon(
                Icons.image,
                size: 100,
              ),
            if (item.firstimage2 != null)
              CachedNetworkImage(
                width: double.infinity,
                fit: BoxFit.fill,
                imageUrl: item.firstimage!,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            Text(item.title),
          ],
        ),
      ),
    );
  }
}
