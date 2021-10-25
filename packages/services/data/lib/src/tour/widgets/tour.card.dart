import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

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
      height: 240,
      title: item.englishTitle,
      onTap: () => TourController.to.view(index),
      borderRadius: 10,
      errorIcon: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Icon(
            Icons.error,
            size: 128,
          ),
        ),
      ),
      errorIconSize: 128,
    );
  }
}
