import 'package:data/data.dart';
import 'package:data/data.functions.dart';
import 'package:flutter/material.dart';

import 'package:widgets/widgets.dart';

class TourViewHomepage extends StatelessWidget {
  TourViewHomepage({Key? key}) : super(key: key);

  final TourController _ = TourController.of;

  @override
  Widget build(BuildContext context) {
    return _.detail.homepageUrl == ''
        ? SizedBox.shrink()
        : Column(
            children: [
              spaceSm,
              GestureDetector(
                onTap: () => launchURL(_.detail.homepageUrl),
                child: Container(
                  height: 30,
                  child: Row(children: [
                    Icon(Icons.language, size: 30, color: Colors.blueAccent),
                    VerticalDivider(),
                    Expanded(
                        child: Text('${_.detail.homepageUrl}', overflow: TextOverflow.ellipsis))
                  ]),
                ),
              ),
            ],
          );
  }
}
