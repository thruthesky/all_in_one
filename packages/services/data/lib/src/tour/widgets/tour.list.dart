import 'package:data/data.dart';
import 'package:data/src/tour/widgets/tour.controller.dart';
import 'package:data/src/tour/widgets/tour.list.menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TourList extends StatefulWidget {
  TourList({
    Key? key,
  }) : super(key: key);

  @override
  _TourListState createState() => _TourListState();
}

class _TourListState extends State<TourList> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    TourController.to.loadPage();
    scrollController.addListener(() {
      if (atBottom) TourController.to.loadPage();
    });
  }

  bool get atBottom {
    return scrollController.offset > (scrollController.position.maxScrollExtent - 240);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TourController>(
      builder: (_) => Column(
        children: [
          TourListMenu(),
          if (_.loading) Center(child: CircularProgressIndicator.adaptive()),
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              controller: scrollController,
              padding: const EdgeInsets.all(5.0),
              // gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 2,
              //   crossAxisSpacing: 5.0,
              //   mainAxisSpacing: 5.0,
              // ),
              itemBuilder: (BuildContext c, int index) {
                return TourCard(item: _.items[index], index: index);
              },
              itemCount: _.items.length,
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          ),
        ],
      ),
    );
  }
}
