import 'feels_like.dart';
import 'temp.dart';
import 'weather.dart';

class Daily {
  num? dt;
  num? sunrise;
  num? sunset;
  num? moonrise;
  num? moonset;
  num? moonPhase;
  Temp? temp;
  FeelsLike? feelsLike;
  num? pressure;
  num? humidity;
  num? dewPoint;
  num? windSpeed;
  num? windDeg;
  num? windGust;
  List<Weather>? weather;
  num? clouds;
  num? pop;
  num? rain;
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
        dt: json['dt'] as num?,
        sunrise: json['sunrise'] as num?,
        sunset: json['sunset'] as num?,
        moonrise: json['moonrise'] as num?,
        moonset: json['moonset'] as num?,
        moonPhase: json['moon_phase'] as num?,
        temp: json['temp'] == null ? null : Temp.fromJson(json['temp'] as Map<String, dynamic>),
        feelsLike: json['feels_like'] == null
            ? null
            : FeelsLike.fromJson(json['feels_like'] as Map<String, dynamic>),
        pressure: json['pressure'] as num?,
        humidity: json['humidity'] as num?,
        dewPoint: json['dew_point'] as num?,
        windSpeed: json['wind_speed'] as num?,
        windDeg: json['wind_deg'] as num?,
        windGust: json['wind_gust'] as num?,
        weather: (json['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
        clouds: json['clouds'] as num?,
        pop: json['pop'] as num?,
        rain: json['rain'] as num?,
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
