import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

///
class TourCard extends StatelessWidget {
  const TourCard({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  final TourApiListItem item;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      imageUrl: item.firstimage,
      height: double.infinity,
      title: item.englishTitle,
      onTap: () => TourController.to.view(index),
      borderRadius: 10,
      imageLoader: Shimmer.fromColors(
        baseColor: Colors.grey.shade50,
        highlightColor: Colors.grey.shade200,
        child: Container(
          // height: index % 2 == 0 ? 125 : 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      imageErrorWidget: Container(
        height: index % 2 == 0 ? 125 : 100,
        child: Center(
          child: Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }
}
