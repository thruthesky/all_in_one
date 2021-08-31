import 'package:data/data.dart';
import 'package:data/src/tour/models/tour.api.area_code.model.dart';
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
  int numOfRows = 20;
  int pageNo = 1;
  int areaCode = 0;
  int sigunguCode = 0;
  List<TourApiAreaCodeModel> cities = [];
  List<TourCard> items = [];

  @override
  void initState() {
    super.initState();
    loadPage();
    scrollController.addListener(() {
      if (atBottom) loadPage();
    });
  }

  resetList({
    int? areaCode,
    int? sigunguCode,
  }) {
    loading = false;
    noMoreData = false;
    pageNo = 1;
    items = [];
    if (areaCode != null) this.areaCode = areaCode;
    if (sigunguCode != null) this.sigunguCode = sigunguCode;
    setState(() {});
    loadPage();
    loadArea();
  }

  setLoading(bool f) {
    setState(() {
      loading = f;
    });
  }

  loadArea() async {
    cities = await TourApi.instance.areaCode(areaCode: areaCode);
    setState(() {});
  }

  loadPage() async {
    print('loading; $loading, noMoreData; $noMoreData');
    if (loading || noMoreData) {
      print('loading on page; $pageNo');
      return;
    }
    setLoading(true);
    print('loading pageNo: $pageNo');
    listModel = await TourApi.instance.areaBasedList(
      areaCode: areaCode,
      sigunguCode: sigunguCode,
      contentTypeId: ContentTypeId.travel,
      pageNo: pageNo,
      numOfRows: numOfRows,
    );

    pageNo++;
    setLoading(false);
    if (listModel.response.body.items.item.length < numOfRows) noMoreData = true;
    listModel.response.body.items.item.forEach((e) {
      items.add(TourCard(item: e, index: 0));
    });
    print('items.length; ${items.length}, totalCount; ${listModel.response.body.totalCount}');
  }

  bool get atBottom {
    return scrollController.offset > (scrollController.position.maxScrollExtent - 240);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DropdownButton<int>(
              value: areaCode,
              items: [
                DropdownMenuItem(value: 0, child: Text('Select location')),
                for (final city in tourCityList)
                  DropdownMenuItem(value: city.code, child: Text(city.name)),
              ],
              onChanged: (int? v) => resetList(areaCode: v!, sigunguCode: 0),
            ),
            if (cities.length > 0)
              DropdownButton<int>(
                value: sigunguCode,
                items: [
                  DropdownMenuItem(value: 0, child: Text('Select sub-location')),
                  for (final city in cities)
                    DropdownMenuItem(value: city.code, child: Text(city.name)),
                ],
                onChanged: (int? v) => resetList(sigunguCode: v!),
              ),
          ],
        ),
        if (loading)
          Center(
            child: CircularProgressIndicator.adaptive(),
          ),
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
              return items[index];
            },
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}
