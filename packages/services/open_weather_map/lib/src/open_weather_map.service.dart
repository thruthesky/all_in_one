import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather/weather.dart';

/// Open Weather API 서비스
///
/// 요약문서 참고: https://docs.google.com/document/d/11mfcHMalG7daf2Hm-kxMTHzdlz3Bo7NcUPjJoUoXwaw/edit#heading=h.p9y2ibbi02t1
class OpenWeatherMapService {
  /// Singleton
  static OpenWeatherMapService? _instance;
  static OpenWeatherMapService get instance {
    if (_instance == null) {
      _instance = OpenWeatherMapService();
    }
    return _instance!;
  }

  /// API Key
  late final String _apiKey;

  /// 현재 날씨
  ///
  /// API 가 실행되면, 현재 날씨를 가져와 이 변수에 저장한다.
  /// 자세한 변수는 소스 코드를 열어 본다.
  Weather? weather;

  /// [updateInterval] 에는 새로운 날씨 데이터를 가져 올(업데이트를 할) 시간 주기 입력.
  /// 초 단위로 입력. 예를 들어, 123 을 입력하면 123 초마다 날씨 정보 업데이트.
  /// 기본 값 1,000 초( 16 분 40초 ).
  late final int _updateInterval;

  /// 현재 사용자의 위치(좌표),
  Position? _position;

  /// 새로운 날씨 데이터를 가져오면 [weatherChanges] 이벤트가 발생한다.
  /// 정확히는 Service 가 실행되면, Open Weather API 에서 (주기적으로) 날씨 정보를 가져온 후, weather 변수에 저장하고, Event 를 발생시킨다.
  /// .listen() 을 하면, .cancel() 을 해 주어야 한다.
  BehaviorSubject<Weather?> weatherChanges = BehaviorSubject.seeded(null);

  late WeatherFactory _wf;

  String get iconUrl {
    return "https://openweathermap.org/img/wn/${weather!.weatherIcon}@2x.png";
  }

  /// 초기화
  ///
  /// 반드시 이 함수가 호출되어야 한다.
  /// [updateInterval] 은 분 단위이다. 기본 값은 15분.
  /// 처음 init() 을 호출할 때에는 async/await 으로 날씨 정보를 가져온다.
  init({required String apiKey, int updateInterval = 15}) async {
    _apiKey = apiKey;
    _updateInterval = updateInterval;
    _wf = new WeatherFactory(_apiKey, language: Language.ENGLISH);

    // print('------> open weather map service init(); $_apiKey, $_updateInterval');

    updateWithLastKnownPosition();
    await updateWeather();

    Timer.periodic(Duration(minutes: _updateInterval), (t) {
      updateWeather();
    });
  }

  /// 마지막 Location 으로 먼저 업데이트를 한번 해 준다. 왜냐하면, 실제 Location 을 가져오는데, 8초 이상 걸리기 때문이다.
  updateWithLastKnownPosition() {
    Geolocator.getLastKnownPosition().then((value) async {
      if (value == null) return;
      _position = value;
      // print('------> getLastKnownPosition; $_position');
      weather = await _wf.currentWeatherByLocation(_position!.latitude, _position!.longitude);
      weatherChanges.add(weather);
    }).catchError((e) {
      /// 처음 앱 실행시, 퍼미션이 없는 경우나 퍼미션이 거절 된 경우 등, 에러 무시.
      print('-------> Ignore exception in updateWithLastKnownPosition(); $e');
    });
  }

  Future updateWeather() async {
    try {
      await _currentLocation();
      if (_position == null) {
        print('----> updateWeather() - failed to get current location');
        return;
      }
      weather = await _wf.currentWeatherByLocation(_position!.latitude, _position!.longitude);
      weatherChanges.add(weather);
    } catch (e) {
      print('-----> Exception on Open Weather Api::$e ------> [ IGNORED ]');
    }
  }

  /// Location 퍼미션을 묻고, 현재 위치를 [weather] 에 업데이트한다.
  _currentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print('--------> Error on Geolocator.getCurrentPosition(); $e');
// 에러 무시
// A request for location permissions is already running, please wait for it to complete before doing another request.
      return null;
    }
  }
}
