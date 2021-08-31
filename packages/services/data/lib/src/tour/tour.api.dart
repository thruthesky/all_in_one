import 'package:data/src/tour/tour.api.list.model.dart';
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
    return "http://api.visitkorea.or.kr/openapi/service/rest/EngService/$operation?ServiceKey=$_apiKey&MobileApp=$_appName&MobileOS=ETC&_type=json";
  }

  Future<TourApiListModel> areaBasedList({required int pageNo, required int numOfRows}) async {
    final path = _queryUrl('areaBasedList') +
        "&contentTypeId=78&areaCode=&sigunguCode=1&cat1=&cat2=&cat3=&listYN=Y&arrange=A&numOfRows=$numOfRows&pageNo=$pageNo";

    final json = await _request(path);
    print('json; $json');
    final model = TourApiListModel.fromJson(json);
    return model;
  }
}
