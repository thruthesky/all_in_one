import 'rain.dart';
import 'weather.dart';

class Hourly {
  int? dt;
  num? temp;
  num? feelsLike;
  int? pressure;
  int? humidity;
  num? dewPoint;
  num? uvi;
  int? clouds;
  int? visibility;
  num? windSpeed;
  int? windDeg;
  num? windGust;
  List<Weather>? weather;
  num? pop;
  Rain? rain;

  Hourly({
    this.dt,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.uvi,
    this.clouds,
    this.visibility,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.weather,
    this.pop,
    this.rain,
  });

  @override
  String toString() {
    return 'Hourly(dt: $dt, temp: $temp, feelsLike: $feelsLike, pressure: $pressure, humidity: $humidity, dewPoint: $dewPoint, uvi: $uvi, clouds: $clouds, visibility: $visibility, windSpeed: $windSpeed, windDeg: $windDeg, windGust: $windGust, weather: $weather, pop: $pop, rain: $rain)';
  }

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        dt: json['dt'] as int?,
        temp: json['temp'] as num?,
        feelsLike: json['feels_like'] as num?,
        pressure: json['pressure'] as int?,
        humidity: json['humidity'] as int?,
        dewPoint: json['dew_point'] as num?,
        uvi: json['uvi'] as num?,
        clouds: json['clouds'] as int?,
        visibility: json['visibility'] as int?,
        windSpeed: json['wind_speed'] as num?,
        windDeg: json['wind_deg'] as int?,
        windGust: json['wind_gust'] as num?,
        weather: (json['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
        pop: json['pop'] as num?,
        rain: json['rain'] == null ? null : Rain.fromJson(json['rain'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'uvi': uvi,
        'clouds': clouds,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'wind_gust': windGust,
        'weather': weather?.map((e) => e.toJson()).toList(),
        'pop': pop,
        'rain': rain?.toJson(),
      };
}
