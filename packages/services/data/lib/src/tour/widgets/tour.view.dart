import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/data.dart';
import 'package:data/src/tour/widgets/tour.controller.dart';
import 'package:data/src/tour/widgets/tour.view.address.dart';
import 'package:data/src/tour/widgets/tour.view.homepage.dart';
import 'package:data/src/tour/widgets/tour.view.phone_number.dart';
import 'package:data/src/tour/widgets/tour.view.thumbnail_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';

class TourView extends StatelessWidget {
  TourView(this.index, {Key? key}) : super(key: key) {
    TourController.to.loadDetails(index).then((x) {
      TourController.of.detail.images.insert(
        0,
        TourImage(
            smallimageurl: TourController.of.detail.firstimage,
            originimgurl: TourController.of.detail.firstimage),
      );
      TourController.of.update();
    });
  }
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TourController>(
      builder: (_) => SingleChildScrollView(
        child: Column(
          children: [
            if (_.items[index].firstimage != '')
              Hero(
                transitionOnUserGestures: true,
                tag: _.items[index].firstimage,
                child: CachedNetworkImage(imageUrl: _.items[index].firstimage),
              ),
            TourViewThumbnailNav(index),
            if (_.detail.contentid == _.items[index].contentid)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sm),
                child: Column(children: [
                  SelectableText(_.detail.overviewText),
                  spaceLg,
                  TourViewAddress(),
                  TourViewHomepage(),
                  TourViewPhoneNumber(),
                  SafeArea(child: spaceLg),
                ]),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sm),
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
