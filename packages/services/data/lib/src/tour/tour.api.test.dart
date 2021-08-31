import 'package:data/data.dart';
import 'package:data/data.functions.dart';

class TourApiTest {
  run() async {
    final res = await TourApi.instance.areaBasedList(pageNo: 1, numOfRows: 16);
    testResultCode(res.response.header.resultCode, msg: 'areaBasedList');
  }
}
