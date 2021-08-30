import 'package:dio/dio.dart';

class TourApi {
  final dio = Dio();

  String apiKey = '';
  String appName = '';

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
    this.apiKey = apiKey;
  }

  String queryUrl(String operation) {
    return "http://api.visitkorea.or.kr/openapi/service/rest/EngService/$operation?ServiceKey=$apiKey&MobileApp=$appName&MobileOS=ETC&_type=json";
  }

  areaBasedList() {
    final path = queryUrl('areaBasedList') +
        "&contentTypeId=78&areaCode=1&sigunguCode=1&cat1=&cat2=&cat3=&listYN=Y&arrange=A&numOfRows=20&pageNo=1";

    return dio.get(path);
  }
}
