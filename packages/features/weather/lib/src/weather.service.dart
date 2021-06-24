import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/src/models/air.model.dart';
import 'package:weather/weather.dart';
import 'package:rxdart/rxdart.dart';

/// 날씨 서비스
///
/// 자세한 설명은, README.md 파일 참고
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

  /// 새로운 날씨 데이터를 가져오면 [weatherChanges] 이벤트가 발생한다.
  BehaviorSubject weatherChanges = BehaviorSubject.seeded(null);

  /// 새로운 대기 오염 데이터를 가져오면 [airChanges] 이벤트가 발생한다.
  /// 참고로, air pollution 의 경우에는 모델을 간단하게 만들었다.
  BehaviorSubject airChanges = BehaviorSubject.seeded(null);

  late final String _apiKey;
  String get weatherApiUrl =>
      'https://api.openweathermap.org/data/2.5/onecall?lat=${_position?.latitude}&lon=${_position?.longitude}&lang=kr&units=metric&appid=$_apiKey';

  String get airApiUrl =>
      'http://api.openweathermap.org/data/2.5/air_pollution?lat=${_position?.latitude}&lon=${_position?.longitude}&appid=$_apiKey';

  Position? _position;

  init({required String apiKey, int updateInterval = 1000}) {
    _apiKey = apiKey;
    _updateInterval = updateInterval;

    updateWeather();
    updateAir();
    Timer.periodic(Duration(seconds: _updateInterval), (t) {
      updateWeather();
      updateAir();
    });
  }

  Future<Position> _currentLocation() async {
    _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return _position!;
  }

  Future<WeatherModel> updateWeather() async {
    await _currentLocation();
    Dio dio = Dio();
    try {
      final res = await dio.get(weatherApiUrl);
      final model = WeatherModel.fromJson(res.data);
      weatherChanges.add(model);
      return model;
    } catch (e) {
      print('@error $e');
      rethrow;
    }
  }

  Future<AirModel> updateAir() async {
    await _currentLocation();
    Dio dio = Dio();
    try {
      final res = await dio.get(airApiUrl);
      final model = AirModel.fromJson(res.data);
      airChanges.add(model);
      return model;
    } catch (e) {
      print('@error $e');
      rethrow;
    }
  }
}
