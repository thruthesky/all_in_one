import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TourCard extends StatelessWidget {
  const TourCard({Key? key, required this.item, required this.index}) : super(key: key);

  final TourApiListItem item;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      imageUrl: item.firstimage,
      title: item.englishTitle,
      onTap: () => TourController.to.view(index),
      borderRadius: 10,
    );
  }
}
