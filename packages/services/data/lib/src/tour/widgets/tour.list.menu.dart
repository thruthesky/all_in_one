import 'package:data/data.dart';
import 'package:data/src/tour/widgets/tour.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourListMenu extends StatelessWidget {
  const TourListMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TourController>(
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 120,
            child: DropdownButton<int>(
              isExpanded: true,
              value: _.contentTypeId,
              items: [
                DropdownMenuItem(value: 0, child: Text('Search By', style: captionSm)),
                for (final type in tourApiSearchTypes)
                  DropdownMenuItem(
                    value: type.id,
                    child: Text(
                      type.label,
                      style: captionSm,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
              onChanged: (int? v) => _.changeContentTypeId(v!),
            ),
          ),
          if (_.displaySearchBox) ...[
            Expanded(
              child: TextField(
                onChanged: (v) {
                  if (v.length > 1) {
                    _.onKeywordChange(v);
                  }
                },
                decoration: InputDecoration(hintText: 'Input search keyword'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _.onCancelSearch(),
            )
          ],
          if (_.displaySearchBox == false && _.operation != '')
            Container(
              width: 130,
              child: DropdownButton<int>(
                isExpanded: true,
                value: _.areaCode,
                items: [
                  DropdownMenuItem(value: 0, child: Text('Select location', style: captionSm)),
                  for (final city in tourCityList)
                    DropdownMenuItem(
                        value: city.code,
                        child: Text(
                          city.name,
                          style: captionSm,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                ],
                onChanged: (int? v) => _.reset(areaCode: v!, sigunguCode: 0),
              ),
            ),
          if (_.displaySearchBox == false && _.operation != '' && _.areaCode != 0)
            Container(
              width: 130,
              child: DropdownButton<int>(
                isExpanded: true,
                value: _.sigunguCode,
                items: [
                  DropdownMenuItem(value: 0, child: Text('Select town', style: captionSm)),
                  for (final city in _.cities)
                    DropdownMenuItem(
                      value: city.code,
                      child: Text(
                        city.name,
                        style: captionSm,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                ],
                onChanged: (int? v) => _.reset(sigunguCode: v!),
              ),
            ),
        ],
      ),
    );
  }
}
