import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';

class TourViewAddress extends StatelessWidget {
  TourViewAddress({Key? key}) : super(key: key);
  final TourController _ = TourController.of;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 30,
        child: Row(
          children: [
            Icon(Icons.location_on, size: 30, color: Colors.redAccent),
            VerticalDivider(),
            Expanded(
              child: Text(
                "${_.detail.addr1} ${_.detail.englishAddr2 != '' ? "" : _.detail.englishAddr2}",
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        try {
          final coords = Coords(_.detail.mapy, _.detail.mapx);
          final title = _.detail.englishTitle;
          final availableMaps = await MapLauncher.installedMaps;

          /// 설치된 지도앱이 없음
          if (availableMaps.length == 0) {
            TourController.to.error('No map application is available');
            return;
          }

          /// 설치된 지도 앱이 하나 뿐인 경우, 그것을 사용
          if (availableMaps.length == 1) {
            try {
              await availableMaps[0].showMarker(
                coords: coords,
                title: title,
                zoom: _.detail.mlevel,
              );
              return;
            } catch (e) {
              TourController.to.error(e);
            }
          }

          /// 아니면, 여러개 중 하나를 선택
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
                              zoom: _.detail.mlevel,
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
    );
  }
}
