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

    print('_request path; $path');
    response = await _dio.get(path);

    return response.data;
  }

  String _queryUrl({
    required String operation,
    String? contentTypeId,
    int? contentId,
    String? areaCode,
    String? sigunguCode,
    int? numOfRows,
    int? pageNo,
  }) {
    String os = 'ETC';
    if (Platform.isAndroid)
      os = 'AND';
    else if (Platform.isIOS) os = 'IOS';
    String url =
        "http://api.visitkorea.or.kr/openapi/service/rest/EngService/$operation?ServiceKey=$_apiKey&MobileApp=$_appName&MobileOS=$os&_type=json";
    if (contentTypeId != null) url += "&contentTypeId=$contentTypeId";
    if (contentId != null) url += "&contentId=$contentId";
    if (areaCode != null) url += "&areaCode=$areaCode";
    if (sigunguCode != null) url += "&sigunguCode=$sigunguCode";
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

  /// 만약, contentTypeId 가 선택되지 않았거나, 0,1,2 이면 전체 콘텐츠 타입을 가져온다.
  Future<TourApiListModel> search({
    required String operation,
    required int areaCode,
    required int sigunguCode,
    required int contentTypeId,
    required int pageNo,
    required int numOfRows,
    required String keyword,
  }) async {
    final path = _queryUrl(
          operation: operation == '' ? TourApiOperations.areaBasedList : operation,
          contentTypeId: contentTypeId < 3 ? '' : contentTypeId.toString(),
          areaCode: areaCode > 0 ? areaCode.toString() : '',
          sigunguCode: sigunguCode > 0 ? sigunguCode.toString() : '',
          pageNo: pageNo,
          numOfRows: numOfRows,
        ) +
        (operation == TourApiOperations.searchKeyword ? "&keyword=$keyword" : "") +
        "&cat1=&cat2=&cat3=&listYN=Y&arrange=O";

    // print('path; $path');
    final json = await _request(path);
    // print('json; $json');
    final model = TourApiListModel.fromJson(json);
    return model;
  }

  Future<TourApiListModel> detailCommon(int? contentId) async {
    final path = _queryUrl(operation: 'detailCommon', contentId: contentId) +
        '&defaultYN=Y&firstImageYN=Y' +
        '&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y&transGuideYN=Y';
    final json = await _request(path);
    print('json;');
    print(json);
    return TourApiListModel.fromJson(json);
  }
}
