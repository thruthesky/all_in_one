import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:rxdart/rxdart.dart';

/// 날씨 서비스
///
/// 초기화 할 때, 새로운 데이터를 가져 올 (업데이트) 주기를 설정 할 수 있다.
/// 그리고 업데이트가 되면 [dataChanges] 이벤트가 발생하는데, 이벤트 listen() 후 cancel() 꼭 해준다.
///
/// 예제) 초기화
/// ```dart
/// WeatherService.instance.init(
///   apiKey: Config.openWeatherMapApiKey, // Api key
///   updateInterval: Config.openWeatherMapUpdateInterval, // 업데이트 주기
/// );
/// ```
///
/// 예제) 업데이트가 발생한 경우 핸들링
/// ```dart
/// WeatherService.instance.dataChanges.listen((data) {
///   final String? icon = (data as WeatherModel).current?.weather?[0].icon;
///     if (icon != null) {
///       print("https://openweathermap.org/img/wn/$icon@2x.png");
///     }
/// });
class WeatherService {
  /// Singleton
  static WeatherService? _instance;
  static WeatherService get instance {
    if (_instance == null) {
      _instance = WeatherService();
    }
    return _instance!;
  }

  /// [updateInterval] 에는 새로운 날씨 데이터를 가져 올(업데이트를 할) 시간 주기 입력.
  /// 초 단위로 입력. 예를 들어, 123 을 입력하면 123 초마다 날씨 정보 업데이트.
  /// 기본 값 1,000 초( 16 분 40초 ).
  late final int _updateInterval;

  /// 새로운 데이터를 가져오면 [dataChanges] 이벤트가 발생한다.
  PublishSubject dataChanges = PublishSubject();

  late final String _apiKey;
  String get apiUrl =>
      'https://api.openweathermap.org/data/2.5/onecall?lat=${_position?.latitude}&lon=${_position?.longitude}&lang=kr&appid=$_apiKey';

  Position? _position;

  init({required String apiKey, int updateInterval = 1000}) {
    _apiKey = apiKey;
    _updateInterval = updateInterval;

    updateWeather();
    Timer.periodic(Duration(seconds: _updateInterval), (t) => updateWeather());
  }

  Future<Position> _currentLocation() async {
    _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return _position!;
  }

  Future<WeatherModel> updateWeather() async {
    await _currentLocation();
    Dio dio = Dio();
    try {
      final res = await dio.get(apiUrl);
      final model = WeatherModel.fromJson(res.data);
      dataChanges.add(model);
      return model;
    } catch (e) {
      print('@error $e');
      rethrow;
    }
  }
}
