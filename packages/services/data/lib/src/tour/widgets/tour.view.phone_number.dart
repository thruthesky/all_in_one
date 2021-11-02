import 'package:data/data.dart';
import 'package:data/data.functions.dart';
import 'package:data/src/tour/widgets/tour.controller.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TourViewPhoneNumber extends StatelessWidget {
  TourViewPhoneNumber({Key? key}) : super(key: key);
  final TourController _ = TourController.of;

  @override
  Widget build(BuildContext context) {
    return _.detail.tel == ''
        ? SizedBox.shrink()
        : Column(
            children: [
              spaceSm,
              GestureDetector(
                onTap: () => launchURL("tel:${_.detail.tel}"),
                child: Container(
                  height: 30,
                  child: Row(children: [
                    Icon(Icons.phone, size: 30, color: Colors.greenAccent),
                    VerticalDivider(),
                    Expanded(
                      child: Text('${_.detail.tel}', maxLines: 2, overflow: TextOverflow.ellipsis),
                    )
                  ]),
                ),
              ),
            ],
          );
  }
}
