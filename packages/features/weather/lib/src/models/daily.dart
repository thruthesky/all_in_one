import 'feels_like.dart';
import 'temp.dart';
import 'weather.dart';

class Daily {
  int? dt;
  int? sunrise;
  int? sunset;
  int? moonrise;
  int? moonset;
  double? moonPhase;
  Temp? temp;
  FeelsLike? feelsLike;
  int? pressure;
  int? humidity;
  double? dewPoint;
  double? windSpeed;
  int? windDeg;
  double? windGust;
  List<Weather>? weather;
  int? clouds;
  num? pop;
  double? rain;
  num? uvi;

  Daily({
    this.dt,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.weather,
    this.clouds,
    this.pop,
    this.rain,
    this.uvi,
  });

  @override
  String toString() {
    return 'Daily(dt: $dt, sunrise: $sunrise, sunset: $sunset, moonrise: $moonrise, moonset: $moonset, moonPhase: $moonPhase, temp: $temp, feelsLike: $feelsLike, pressure: $pressure, humidity: $humidity, dewPoint: $dewPoint, windSpeed: $windSpeed, windDeg: $windDeg, windGust: $windGust, weather: $weather, clouds: $clouds, pop: $pop, rain: $rain, uvi: $uvi)';
  }

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        dt: json['dt'] as int?,
        sunrise: json['sunrise'] as int?,
        sunset: json['sunset'] as int?,
        moonrise: json['moonrise'] as int?,
        moonset: json['moonset'] as int?,
        moonPhase: json['moon_phase'] as double?,
        temp: json['temp'] == null ? null : Temp.fromJson(json['temp'] as Map<String, dynamic>),
        feelsLike: json['feels_like'] == null
            ? null
            : FeelsLike.fromJson(json['feels_like'] as Map<String, dynamic>),
        pressure: json['pressure'] as int?,
        humidity: json['humidity'] as int?,
        dewPoint: json['dew_point'] as double?,
        windSpeed: json['wind_speed'] as double?,
        windDeg: json['wind_deg'] as int?,
        windGust: json['wind_gust'] as double?,
        weather: (json['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
        clouds: json['clouds'] as int?,
        pop: json['pop'] as num?,
        rain: json['rain'] as double?,
        uvi: json['uvi'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'sunrise': sunrise,
        'sunset': sunset,
        'moonrise': moonrise,
        'moonset': moonset,
        'moon_phase': moonPhase,
        'temp': temp?.toJson(),
        'feels_like': feelsLike?.toJson(),
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'wind_gust': windGust,
        'weather': weather?.map((e) => e.toJson()).toList(),
        'clouds': clouds,
        'pop': pop,
        'rain': rain,
        'uvi': uvi,
      };
}
