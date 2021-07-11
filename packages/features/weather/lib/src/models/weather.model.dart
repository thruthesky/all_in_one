import 'package:weather/src/models/current.dart';
import 'package:weather/src/models/daily.dart';
import 'package:weather/src/models/hourly.dart';
import 'package:weather/src/models/minutely.dart';

class WeatherModel {
  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  Current? current;
  List<Minutely>? minutely;
  List<Hourly>? hourly;
  List<Daily>? daily;

  WeatherModel({
    this.lat = 0.0,
    this.lon = 0.0,
    this.timezone = '',
    this.timezoneOffset = 0,
    this.current,
    this.minutely,
    this.hourly,
    this.daily,
  });

  @override
  String toString() {
    return 'WeatherModel( ${toJson()} )';
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        lat: json['lat'] ?? 0,
        lon: json['lon'] ?? 0,
        timezone: json['timezone'] ?? '',
        timezoneOffset: json['timezone_offset'] ?? 0,
        current: Current.fromJson(json['current']),
        minutely: (json['minutely'] as List<dynamic>?)
            ?.map((e) => Minutely.fromJson(e as Map<String, dynamic>))
            .toList(),
        hourly: (json['hourly'] as List<dynamic>?)
            ?.map((e) => Hourly.fromJson(e as Map<String, dynamic>))
            .toList(),
        daily: (json['daily'] as List<dynamic>?)
            ?.map((e) => Daily.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
        'timezone': timezone,
        'timezone_offset': timezoneOffset,
        'current': current.toString(),
        'minutely': minutely.toString(),
        'hourly': hourly.toString(),
        'daily': daily.toString(),
      };
}
