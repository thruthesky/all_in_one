import 'package:data/data.dart';
import 'package:data/data.functions.dart';
import 'package:flutter/material.dart';

import 'package:widgets/widgets.dart';

class TourItemViewHomepage extends StatelessWidget {
  const TourItemViewHomepage(this.item, this.detail, {Key? key}) : super(key: key);

  final TourApiListItem item;
  final TourApiListItem detail;

  @override
  Widget build(BuildContext context) {
    return detail.homepageUrl == ''
        ? SizedBox.shrink()
        : Column(
            children: [
              spaceSm,
              GestureDetector(
                onTap: () => launchURL(detail.homepageUrl),
                child: Container(
                  height: 30,
                  child: Row(children: [
                    Icon(Icons.language, size: 30, color: Colors.blueAccent),
                    VerticalDivider(),
                    Expanded(child: Text('${detail.homepageUrl}', overflow: TextOverflow.ellipsis))
                  ]),
                ),
              ),
            ],
          );
  }
}
