import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/data.dart';
import 'package:data/src/tour/widgets/tour.controller.dart';
import 'package:data/src/tour/widgets/tour.view.address.dart';
import 'package:data/src/tour/widgets/tour.view.homepage.dart';
import 'package:data/src/tour/widgets/tour.view.phone_number.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';

class TourView extends StatelessWidget {
  TourView(this.index, {Key? key}) : super(key: key) {
    TourController.to.loadDetails(index);
  }
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TourController>(
      builder: (_) => SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.all(16),
          child: Column(
            children: [
              if (_.items[index].firstimage != '')
                Hero(
                  transitionOnUserGestures: true,
                  tag: _.items[index].firstimage,
                  child: CachedNetworkImage(imageUrl: _.items[index].firstimage),
                ),
              Wrap(children: [
                for (final image in _.detail.images)
                  Container(width: 80, height: 80, child: CacheImage(image.smallimageurl)),
              ]),
              if (_.detail.contentid == _.items[index].contentid)
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SelectableText(_.detail.overviewText),
                    spaceLg,
                    TourViewAddress(),
                    TourViewHomepage(),
                    TourViewPhoneNumber(),
                  ]),
                )
              else
                LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
