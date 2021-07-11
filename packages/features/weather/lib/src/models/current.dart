import 'weather.dart';

class Current {
  num? dt;
  num? sunrise;
  num? sunset;
  num? temp;
  num? feelsLike;
  num? pressure;
  num? humidity;
  num? dewPoint;
  num? uvi;
  num? clouds;
  num? visibility;
  num? windSpeed;
  num? windDeg;
  num? windGust;
  List<Weather>? weather;

  Current({
    this.dt,
    this.sunrise,
    this.sunset,
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
  });

  String? get icon => weather?[0].icon;
  String get iconUrl => "https://openweathermap.org/img/wn/$icon@2x.png";
  String? get description {
    String? d = weather?[0].description;
    String? m = weather?[0].main;
    if (m == null) return '';
    if (m == 'Clouds') return '흐림';

    return d;
  }

  num? get temperature => temp?.round();

  @override
  String toString() {
    return 'Current(dt: $dt, sunrise: $sunrise, sunset: $sunset, temp: $temp, feelsLike: $feelsLike, pressure: $pressure, humidity: $humidity, dewPoint: $dewPoint, uvi: $uvi, clouds: $clouds, visibility: $visibility, windSpeed: $windSpeed, windDeg: $windDeg, windGust: $windGust, weather: $weather)';
  }

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        dt: json['dt'] as num?,
        sunrise: json['sunrise'] as num?,
        sunset: json['sunset'] as num?,
        temp: json['temp'] as num?,
        feelsLike: json['feels_like'] as num?,
        pressure: json['pressure'] as num?,
        humidity: json['humidity'] as num?,
        dewPoint: json['dew_point'] as num?,
        uvi: json['uvi'] as num?,
        clouds: json['clouds'] as num?,
        visibility: json['visibility'] as num?,
        windSpeed: json['wind_speed'] as num?,
        windDeg: json['wind_deg'] as num?,
        windGust: json['wind_gust'] as num?,
        weather: (json['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'sunrise': sunrise,
        'sunset': sunset,
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
      };
}
