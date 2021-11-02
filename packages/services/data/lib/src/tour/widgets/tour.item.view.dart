import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/data.dart';
import 'package:data/src/tour/widgets/tour.item.view.address.dart';
import 'package:data/src/tour/widgets/tour.item.view.homepage.dart';
import 'package:data/src/tour/widgets/tour.item.view.phone_number.dart';
import 'package:data/src/tour/widgets/tour.item.view.thumbnail_nav.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TourItemView extends StatefulWidget {
  TourItemView(this.item, this.error, {Key? key}) : super(key: key);
  // {
  //   TourController.to.loadDetails(index).then((x) {
  //     TourController.of.detail.images.insert(
  //       0,
  //       TourImage(
  //         smallimageurl: TourController.of.detail.firstimage,
  //         originimgurl: TourController.of.detail.firstimage,
  //       ),
  //     );
  //     TourController.of.update();
  //   });
  // }

  final TourApiListItem item;
  final Function error;

  @override
  State<TourItemView> createState() => _TourItemViewState();
}

class _TourItemViewState extends State<TourItemView> {
  TourApiListItem detail = TourApiListItem.fromJson({});

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    try {
      detail = TourApiListItem.fromJson({});
      final re = await TourApi.instance.details(widget.item.contentid);
      detail = re.response.body.items.item[0];
      detail.images.insert(
        0,
        TourImage(smallimageurl: detail.firstimage, originimgurl: detail.firstimage),
      );
      setState(() {});
    } catch (e) {
      widget.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.item.firstimage != '')
            Hero(
              transitionOnUserGestures: true,
              tag: widget.item.firstimage,
              child: CachedNetworkImage(imageUrl: widget.item.firstimage),
            ),
          TourItemViewThumbnailNav(widget.item, detail, () {
            setState(() {});
          }),
          if (detail.contentid == widget.item.contentid)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sm),
              child: Column(children: [
                SelectableText(detail.overviewText),
                spaceLg,
                TourItemViewAddress(widget.item, detail),
                TourItemViewHomepage(widget.item, detail),
                TourItemViewPhoneNumber(widget.item, detail),
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
    );
  }
}
