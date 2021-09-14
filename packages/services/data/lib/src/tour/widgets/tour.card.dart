import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TourCard extends StatelessWidget {
  const TourCard({Key? key, required this.item, required this.index}) : super(key: key);

  final TourApiListItem item;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => TourController.to.view(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          // color: index % 2 == 0 ? Colors.grey : Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          children: [
            if (item.firstimage2 == '')
              Icon(
                Icons.image,
                size: 100,
              ),
            if (item.firstimage2 != '')
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Hero(
                  tag: item.firstimage,
                  child: CachedNetworkImage(
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    imageUrl: item.firstimage,
                    placeholder: (context, url) => Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade50,
                        highlightColor: Colors.grey.shade200,
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.grey.shade50,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  item.englishTitle,
                  maxLines: 2,
                  style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
                ),
              ),
              left: 0,
              right: 0,
              bottom: 0,
            ),
          ],
        ),
      ),
    );
  }
}
