import 'package:data/data.dart';
import 'package:data/data.functions.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TourItemViewPhoneNumber extends StatelessWidget {
  const TourItemViewPhoneNumber(this.item, this.detail, {Key? key}) : super(key: key);

  final TourApiListItem item;
  final TourApiListItem detail;

  @override
  Widget build(BuildContext context) {
    return detail.tel == ''
        ? SizedBox.shrink()
        : Column(children: [
            spaceSm,
            GestureDetector(
              onTap: () => launchURL("tel:${detail.tel}"),
              child: Container(
                height: 30,
                child: Row(children: [
                  Icon(Icons.phone, size: 30, color: Colors.greenAccent),
                  VerticalDivider(),
                  Expanded(
                    child: Text('${detail.tel}', maxLines: 2, overflow: TextOverflow.ellipsis),
                  )
                ]),
              ),
            ),
          ]);
  }
}
