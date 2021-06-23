import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:rxdart/rxdart.dart';

class WeatherService {
  /// Singleton
  static WeatherService? _instance;
  static WeatherService get instance {
    if (_instance == null) {
      _instance = WeatherService();
    }
    return _instance!;
  }

  PublishSubject data = PublishSubject();

  late final String apiKey;
  String get apiUrl =>
      'https://api.openweathermap.org/data/2.5/onecall?lat=${_position?.latitude}&lon=${_position?.longitude}&lang=kr&appid=$apiKey';

  Position? _position;

  init({required String apiKey}) {
    this.apiKey = apiKey;

    updateWeather();
    Timer.periodic(Duration(minutes: 3), (t) => updateWeather());
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
      data.add(model);
      return model;
    } catch (e) {
      print('@error $e');
      rethrow;
    }
  }
}
