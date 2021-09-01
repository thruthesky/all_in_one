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
    required String contentTypeId,
    required String areaCode,
    required String sigunguCode,
    required int numOfRows,
    required int pageNo,
  }) {
    String os = 'ETC';
    if (Platform.isAndroid)
      os = 'AND';
    else if (Platform.isIOS) os = 'IOS';
    return "http://api.visitkorea.or.kr/openapi/service/rest/EngService/$operation?ServiceKey=$_apiKey&MobileApp=$_appName&MobileOS=$os&contentTypeId=$contentTypeId&areaCode=$areaCode&sigunguCode=$sigunguCode&numOfRows=$numOfRows&pageNo=$pageNo&_type=json";
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
}
