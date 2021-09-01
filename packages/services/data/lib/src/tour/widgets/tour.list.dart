import 'package:data/src/tour/widgets/tour.list.controller.dart';
import 'package:data/src/tour/widgets/tour.list.menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class TourList extends StatefulWidget {
  TourList({
    Key? key,
  }) : super(key: key);

  @override
  _TourListState createState() => _TourListState();
}

class _TourListState extends State<TourList> {
  final scrollController = ScrollController();
  final tc = Get.put(TourListController());

  @override
  void initState() {
    super.initState();
    tc.loadPage();
    scrollController.addListener(() {
      if (atBottom) tc.loadPage();
    });
  }

  bool get atBottom {
    return scrollController.offset > (scrollController.position.maxScrollExtent - 240);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TourListController>(
      builder: (_) => Column(
        children: [
          TourListMenu(),
          if (_.loading) Center(child: CircularProgressIndicator.adaptive()),
          Expanded(
            child: WaterfallFlow.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(5.0),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemBuilder: (BuildContext c, int index) {
                return _.items[index];
              },
              itemCount: _.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
