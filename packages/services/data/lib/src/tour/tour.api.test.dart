// import 'package:data/data.dart';
// import 'package:data/data.functions.dart';

import 'package:data/data.dart';

class TourApiTest {
  run() async {
    final res = await TourApi.instance.search(
      operation: TourApiOperations.searchStay,
      areaCode: 36,
      sigunguCode: 4,
      contentTypeId: ContentTypeId.travel,
      pageNo: 1,
      numOfRows: 20,
      keyword: '',
    );

    print('res; $res');
    print(res.response.body.items.item);
    // testResultCode(res.response.header.resultCode, msg: 'areaBasedList');
  }
}
