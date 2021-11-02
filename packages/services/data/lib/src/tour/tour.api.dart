import 'dart:io';

import 'package:data/data.dart';
import 'package:data/src/tour/models/tour.api.area_code.model.dart';
import 'package:data/src/tour/models/tour.api.list.model.dart';
import 'package:dio/dio.dart';

class TourApi {
  final _dio = Dio();

  String _apiKey = '';
  String _appName = '';

  /// TourApi Singleton
  static TourApi? _instance;
  static TourApi get instance {
    if (_instance == null) {
      _instance = TourApi();
    }

    return _instance!;
  }

  init({
    required String apiKey,
    required String appName,
  }) {
    _apiKey = apiKey;
    _appName = appName;
  }

  Future _request(String path) async {
    Response response;

    // print('tour.api.dart :: _request path; $path');
    response = await _dio.get(path);

    return response.data;
  }

  String _queryUrl({
    required String operation,
    String contentTypeId = '',
    int? contentId,
    String? areaCode,
    String? sigunguCode,
    int? numOfRows,
    int? pageNo,
    String cat1 = '',
    String cat2 = '',
    String cat3 = '',
  }) {
    String os = 'ETC';
    if (Platform.isAndroid)
      os = 'AND';
    else if (Platform.isIOS) os = 'IOS';
    String url =
        "http://api.visitkorea.or.kr/openapi/service/rest/EngService/$operation?ServiceKey=$_apiKey&MobileApp=$_appName&MobileOS=$os&_type=json";
    url += "&contentTypeId=$contentTypeId";
    if (contentId != null) url += "&contentId=$contentId";
    if (areaCode != null) url += "&areaCode=$areaCode";
    if (sigunguCode != null) url += "&sigunguCode=$sigunguCode";
    if (cat1 != '') url += "&cat1=$cat1";
    if (cat2 != '') url += "&cat2=$cat2";
    if (cat3 != '') url += "&cat3=$cat3";

    if (numOfRows != null) url += "&numOfRows=$numOfRows";
    if (pageNo != null) url += "&pageNo=$pageNo";

    return url;
  }

  Future<List<TourApiAreaCodeModel>> areaCode({required int areaCode}) async {
    final path = _queryUrl(
        operation: 'areaCode',
        contentTypeId: '',
        areaCode: areaCode.toString(),
        sigunguCode: '',
        numOfRows: 9999,
        pageNo: 1);
    final json = await _request(path);
    final List<TourApiAreaCodeModel> area = [];
    for (final item in json['response']['body']['items']['item']) {
      area.add(TourApiAreaCodeModel.fromJson(item));
    }
    return area;
  }

  /// 만약, contentTypeId 가 선택되지 않았거나, 0,1,2 이면 _queryUrl 에 빈 문자열을 전달해서, 전체 콘텐츠 타입을 가져온다.
  /// 참고, README ## 관광지 정보 검색 방법
  Future<TourApiListModel> search({
    String operation = '',
    int areaCode = 0,
    int sigunguCode = 0,
    int contentTypeId = 0,
    int pageNo = 1,
    int numOfRows = 10,
    String keyword = '',
    String cat1 = '',
    String cat2 = '',
    String cat3 = '',
  }) async {
    assert(operation == TourApiOperations.areaBasedList ||
        operation == TourApiOperations.locationBasedList ||
        operation == TourApiOperations.searchFestival ||
        operation == TourApiOperations.searchKeyword ||
        operation == TourApiOperations.searchStay);
    final path = _queryUrl(
          operation: operation == '' ? TourApiOperations.areaBasedList : operation,
          contentTypeId: contentTypeId < 3 ? '' : contentTypeId.toString(),
          areaCode: areaCode > 0 ? areaCode.toString() : '',
          sigunguCode: sigunguCode > 0 ? sigunguCode.toString() : '',
          pageNo: pageNo,
          numOfRows: numOfRows,
          cat1: cat1,
          cat2: cat2,
          cat3: cat3,
        ) +
        (operation == TourApiOperations.searchKeyword ? "&keyword=$keyword" : "") +
        "&cat1=&cat2=&cat3=&listYN=Y&arrange=O";

    // print('path; $path');
    final json = await _request(path);
    // print('json; $json');
    final model = TourApiListModel.fromJson(json);
    return model;
  }

  Future<TourApiListModel> details(int? contentId) async {
    List<Future> futures = [];
    final pathDetailCommon = _queryUrl(operation: 'detailCommon', contentId: contentId) +
        '&defaultYN=Y&firstImageYN=Y' +
        '&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y&transGuideYN=Y';
    final pathDetailIntro = _queryUrl(operation: 'detailImage', contentId: contentId);

    // final json = await _request(path);

    futures.add(_request(pathDetailCommon));
    futures.add(_request(pathDetailIntro));

    final res = await Future.wait(futures);

    final model = TourApiListModel.fromJson(res[0]);
    model.addMoreImages(res[1]);
    return model;
  }
}
