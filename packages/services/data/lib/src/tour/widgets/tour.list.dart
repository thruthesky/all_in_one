import 'package:data/data.dart';
import 'package:data/src/tour/widgets/tour.card.dart';
import 'package:flutter/material.dart';
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

  late TourApiListModel listModel;

  bool loading = false;
  bool noMoreData = false;
  int numOfRows = 16;
  int pageNo = 1;
  List<TourCard> items = [];

  @override
  void initState() {
    super.initState();
    loadPage();
    scrollController.addListener(() {
      if (atBottom) loadPage();
    });
  }

  setLoading(bool f) {
    setState(() {
      loading = f;
    });
  }

  loadPage() async {
    print('loading; $loading, noMoreData; $noMoreData');
    if (loading || noMoreData) {
      print('loading on page; $pageNo');
      return;
    }
    setLoading(true);
    print('loading pageNo: $pageNo');
    listModel = await TourApi.instance.areaBasedList(pageNo: pageNo, numOfRows: numOfRows);

    pageNo++;
    setLoading(false);
    if (listModel.response.body.items.item.length < numOfRows) noMoreData = true;
    listModel.response.body.items.item.forEach((e) {
      items.add(TourCard(item: e, index: 0));
    });
    print('items.length; ${items.length}');
  }

  bool get atBottom {
    return scrollController.offset > (scrollController.position.maxScrollExtent - 240);
  }

  @override
  Widget build(BuildContext context) {
    return WaterfallFlow.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(5.0),
      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemBuilder: (BuildContext c, int index) {
        return items[index];
      },
      itemCount: items.length,
    );
  }
}
