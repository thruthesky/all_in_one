import 'dart:io';

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

    response = await _dio.get(path);

    return response.data;
  }

  String _queryUrl(String operation) {
    String os = 'ETC';
    if (Platform.isAndroid)
      os = 'AND';
    else if (Platform.isIOS) os = 'IOS';
    return "http://api.visitkorea.or.kr/openapi/service/rest/EngService/$operation?ServiceKey=$_apiKey&MobileApp=$_appName&MobileOS=$os&_type=json";
  }

  Future<List<TourApiAreaCodeModel>> areaCode({required int areaCode}) async {
    final path = _queryUrl('areaCode') + "&areaCode=$areaCode&numOfRows=9999&pageNo=1";
    final json = await _request(path);
    final List<TourApiAreaCodeModel> area = [];
    for (final item in json['response']['body']['items']['item']) {
      area.add(TourApiAreaCodeModel.fromJson(item));
    }
    return area;
  }

  Future<TourApiListModel> areaBasedList({
    required int areaCode,
    required int sigunguCode,
    required int contentTypeId,
    required int pageNo,
    required int numOfRows,
  }) async {
    String ac = '';
    String subAc = '';
    if (areaCode > 0) ac = areaCode.toString();
    if (sigunguCode > 0) subAc = sigunguCode.toString();
    final path = _queryUrl('areaBasedList') +
        "&contentTypeId=$contentTypeId&areaCode=$ac&sigunguCode=$subAc&cat1=&cat2=&cat3=&listYN=Y&arrange=O&numOfRows=$numOfRows&pageNo=$pageNo";

    // print('path; $path');
    final json = await _request(path);
    // print('json; $json');
    final model = TourApiListModel.fromJson(json);
    return model;
  }
}
