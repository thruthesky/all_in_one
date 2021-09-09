import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';

class TourView extends StatelessWidget {
  TourView(this.index, {Key? key}) : super(key: key) {
    TourController.to.loadDetailCommon(index);
  }
  final int index;
  final space = SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TourController>(
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: _.detail.firstimage),
            space,
            GestureDetector(
              child: Column(
                children: [
                  Text(_.detail.addr1),
                  if (_.detail.addr2 != '') Text(_.detail.addr2),
                  Text('Open map'),
                ],
              ),
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                try {
                  final coords = Coords(_.detail.mapx, _.detail.mapy);
                  final title = _.detail.englishTitle;
                  final availableMaps = await MapLauncher.installedMaps;

                  if (availableMaps.length == 1) {
                    try {
                      await availableMaps[0].showMarker(
                        coords: coords,
                        title: title,
                      );
                    } catch (e) {
                      TourController.to.error(e);
                    }
                  }

                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: SingleChildScrollView(
                          child: Container(
                            child: Wrap(
                              children: <Widget>[
                                for (var map in availableMaps)
                                  ListTile(
                                    onTap: () => map.showMarker(
                                      coords: coords,
                                      title: title,
                                    ),
                                    title: Text(map.mapName),
                                    leading: SvgPicture.asset(
                                      map.icon,
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } catch (e) {
                  TourController.to.error(e);
                }
              },
            ),
            space,
            Text(_.detail.overviewText),
          ],
        ),
      ),
    );
  }
}
