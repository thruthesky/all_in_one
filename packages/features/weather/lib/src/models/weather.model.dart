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


// {
//   "lat": 37.3211,
//   "lon": 126.8202,
//   "timezone": "Asia/Seoul",
//   "timezone_offset": 32400,
//   "current": {
//     "dt": 1624456758,
//     "sunrise": 1624392769,
//     "sunset": 1624445810,
//     "temp": 293.04,
//     "feels_like": 293.15,
//     "pressure": 1011,
//     "humidity": 79,
//     "dew_point": 289.29,
//     "uvi": 0,
//     "clouds": 22,
//     "visibility": 10000,
//     "wind_speed": 1.36,
//     "wind_deg": 155,
//     "wind_gust": 2.22,
//     "weather": [
//       {
//         "id": 801,
//         "main": "Clouds",
//         "description": "약간의 구름이 낀 하늘",
//         "icon": "02n"
//       }
//     ]
//   },
//   "minutely": [
//     {
//       "dt": 1624456800,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624456860,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624456920,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624456980,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457040,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457100,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457160,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457220,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457280,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457340,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457400,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457460,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457520,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457580,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457640,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457700,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457760,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457820,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457880,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624457940,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458000,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458060,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458120,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458180,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458240,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458300,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458360,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458420,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458480,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458540,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458600,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458660,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458720,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458780,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458840,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458900,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624458960,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459020,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459080,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459140,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459200,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459260,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459320,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459380,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459440,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459500,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459560,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459620,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459680,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459740,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459800,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459860,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459920,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624459980,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624460040,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624460100,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624460160,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624460220,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624460280,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624460340,
//       "precipitation": 0
//     },
//     {
//       "dt": 1624460400,
//       "precipitation": 0
//     }
//   ],
//   "hourly": [
//     {
//       "dt": 1624453200,
//       "temp": 293.3,
//       "feels_like": 293.41,
//       "pressure": 1011,
//       "humidity": 78,
//       "dew_point": 289.35,
//       "uvi": 0,
//       "clouds": 22,
//       "visibility": 10000,
//       "wind_speed": 0.63,
//       "wind_deg": 178,
//       "wind_gust": 1.43,
//       "weather": [
//         {
//           "id": 500,
//           "main": "Rain",
//           "description": "실 비",
//           "icon": "10n"
//         }
//       ],
//       "pop": 0.36,
//       "rain": {
//         "1h": 0.15
//       }
//     },
//     {
//       "dt": 1624456800,
//       "temp": 293.04,
//       "feels_like": 293.15,
//       "pressure": 1011,
//       "humidity": 79,
//       "dew_point": 289.29,
//       "uvi": 0,
//       "clouds": 22,
//       "visibility": 10000,
//       "wind_speed": 1.36,
//       "wind_deg": 155,
//       "wind_gust": 2.22,
//       "weather": [
//         {
//           "id": 801,
//           "main": "Clouds",
//           "description": "약간의 구름이 낀 하늘",
//           "icon": "02n"
//         }
//       ],
//       "pop": 0.12
//     },
//     {
//       "dt": 1624460400,
//       "temp": 293.17,
//       "feels_like": 293.32,
//       "pressure": 1011,
//       "humidity": 80,
//       "dew_point": 289.62,
//       "uvi": 0,
//       "clouds": 21,
//       "visibility": 10000,
//       "wind_speed": 1.41,
//       "wind_deg": 158,
//       "wind_gust": 2.32,
//       "weather": [
//         {
//           "id": 801,
//           "main": "Clouds",
//           "description": "약간의 구름이 낀 하늘",
//           "icon": "02n"
//         }
//       ],
//       "pop": 0.08
//     },
//     {
//       "dt": 1624464000,
//       "temp": 293.14,
//       "feels_like": 293.31,
//       "pressure": 1011,
//       "humidity": 81,
//       "dew_point": 289.78,
//       "uvi": 0,
//       "clouds": 18,
//       "visibility": 10000,
//       "wind_speed": 1.73,
//       "wind_deg": 145,
//       "wind_gust": 2.7,
//       "weather": [
//         {
//           "id": 801,
//           "main": "Clouds",
//           "description": "약간의 구름이 낀 하늘",
//           "icon": "02n"
//         }
//       ],
//       "pop": 0.08
//     },
//     {
//       "dt": 1624467600,
//       "temp": 292.97,
//       "feels_like": 293.15,
//       "pressure": 1011,
//       "humidity": 82,
//       "dew_point": 289.81,
//       "uvi": 0,
//       "clouds": 15,
//       "visibility": 10000,
//       "wind_speed": 1.77,
//       "wind_deg": 144,
//       "wind_gust": 2.85,
//       "weather": [
//         {
//           "id": 801,
//           "main": "Clouds",
//           "description": "약간의 구름이 낀 하늘",
//           "icon": "02n"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624471200,
//       "temp": 292.74,
//       "feels_like": 292.95,
//       "pressure": 1011,
//       "humidity": 84,
//       "dew_point": 289.96,
//       "uvi": 0,
//       "clouds": 11,
//       "visibility": 10000,
//       "wind_speed": 1.77,
//       "wind_deg": 141,
//       "wind_gust": 2.61,
//       "weather": [
//         {
//           "id": 801,
//           "main": "Clouds",
//           "description": "약간의 구름이 낀 하늘",
//           "icon": "02n"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624474800,
//       "temp": 292.38,
//       "feels_like": 292.6,
//       "pressure": 1011,
//       "humidity": 86,
//       "dew_point": 289.8,
//       "uvi": 0,
//       "clouds": 0,
//       "visibility": 10000,
//       "wind_speed": 1.79,
//       "wind_deg": 132,
//       "wind_gust": 2.5,
//       "weather": [
//         {
//           "id": 800,
//           "main": "Clear",
//           "description": "맑음",
//           "icon": "01n"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624478400,
//       "temp": 292.12,
//       "feels_like": 292.34,
//       "pressure": 1012,
//       "humidity": 87,
//       "dew_point": 289.7,
//       "uvi": 0,
//       "clouds": 0,
//       "visibility": 10000,
//       "wind_speed": 1.44,
//       "wind_deg": 142,
//       "wind_gust": 1.79,
//       "weather": [
//         {
//           "id": 800,
//           "main": "Clear",
//           "description": "맑음",
//           "icon": "01n"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624482000,
//       "temp": 292.25,
//       "feels_like": 292.46,
//       "pressure": 1012,
//       "humidity": 86,
//       "dew_point": 289.7,
//       "uvi": 0.15,
//       "clouds": 0,
//       "visibility": 10000,
//       "wind_speed": 1.61,
//       "wind_deg": 127,
//       "wind_gust": 2.1,
//       "weather": [
//         {
//           "id": 800,
//           "main": "Clear",
//           "description": "맑음",
//           "icon": "01d"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624485600,
//       "temp": 293.05,
//       "feels_like": 293.24,
//       "pressure": 1012,
//       "humidity": 82,
//       "dew_point": 289.64,
//       "uvi": 0.66,
//       "clouds": 1,
//       "visibility": 10000,
//       "wind_speed": 1.76,
//       "wind_deg": 121,
//       "wind_gust": 2.34,
//       "weather": [
//         {
//           "id": 800,
//           "main": "Clear",
//           "description": "맑음",
//           "icon": "01d"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624489200,
//       "temp": 294.15,
//       "feels_like": 294.29,
//       "pressure": 1012,
//       "humidity": 76,
//       "dew_point": 289.66,
//       "uvi": 1.75,
//       "clouds": 3,
//       "visibility": 10000,
//       "wind_speed": 1.98,
//       "wind_deg": 128,
//       "wind_gust": 2.63,
//       "weather": [
//         {
//           "id": 800,
//           "main": "Clear",
//           "description": "맑음",
//           "icon": "01d"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624492800,
//       "temp": 295.48,
//       "feels_like": 295.6,
//       "pressure": 1012,
//       "humidity": 70,
//       "dew_point": 289.61,
//       "uvi": 3.45,
//       "clouds": 4,
//       "visibility": 10000,
//       "wind_speed": 2.03,
//       "wind_deg": 129,
//       "wind_gust": 2.59,
//       "weather": [
//         {
//           "id": 800,
//           "main": "Clear",
//           "description": "맑음",
//           "icon": "01d"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624496400,
//       "temp": 296.93,
//       "feels_like": 297.03,
//       "pressure": 1011,
//       "humidity": 64,
//       "dew_point": 289.48,
//       "uvi": 5.56,
//       "clouds": 11,
//       "visibility": 10000,
//       "wind_speed": 1.53,
//       "wind_deg": 169,
//       "wind_gust": 1.85,
//       "weather": [
//         {
//           "id": 801,
//           "main": "Clouds",
//           "description": "약간의 구름이 낀 하늘",
//           "icon": "02d"
//         }
//       ],
//       "pop": 0.1
//     },
//     {
//       "dt": 1624500000,
//       "temp": 297.88,
//       "feels_like": 297.98,
//       "pressure": 1011,
//       "humidity": 60,
//       "dew_point": 289.34,
//       "uvi": 7.41,
//       "clouds": 55,
//       "visibility": 10000,
//       "wind_speed": 1.86,
//       "wind_deg": 212,
//       "wind_gust": 1.78,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.27
//     },
//     {
//       "dt": 1624503600,
//       "temp": 298.08,
//       "feels_like": 298.2,
//       "pressure": 1011,
//       "humidity": 60,
//       "dew_point": 289.34,
//       "uvi": 8.54,
//       "clouds": 64,
//       "visibility": 10000,
//       "wind_speed": 3.3,
//       "wind_deg": 251,
//       "wind_gust": 2.26,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.41
//     },
//     {
//       "dt": 1624507200,
//       "temp": 297.69,
//       "feels_like": 297.82,
//       "pressure": 1010,
//       "humidity": 62,
//       "dew_point": 289.35,
//       "uvi": 8.72,
//       "clouds": 63,
//       "visibility": 10000,
//       "wind_speed": 4.37,
//       "wind_deg": 258,
//       "wind_gust": 3.18,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.45
//     },
//     {
//       "dt": 1624510800,
//       "temp": 296.99,
//       "feels_like": 297.13,
//       "pressure": 1010,
//       "humidity": 65,
//       "dew_point": 289.66,
//       "uvi": 7.69,
//       "clouds": 64,
//       "visibility": 10000,
//       "wind_speed": 4.63,
//       "wind_deg": 262,
//       "wind_gust": 3.83,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.57
//     },
//     {
//       "dt": 1624514400,
//       "temp": 296.92,
//       "feels_like": 297.08,
//       "pressure": 1010,
//       "humidity": 66,
//       "dew_point": 289.77,
//       "uvi": 5.89,
//       "clouds": 67,
//       "visibility": 10000,
//       "wind_speed": 4.36,
//       "wind_deg": 270,
//       "wind_gust": 3.72,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.53
//     },
//     {
//       "dt": 1624518000,
//       "temp": 296.7,
//       "feels_like": 296.86,
//       "pressure": 1010,
//       "humidity": 67,
//       "dew_point": 289.81,
//       "uvi": 3.77,
//       "clouds": 100,
//       "visibility": 10000,
//       "wind_speed": 4.05,
//       "wind_deg": 278,
//       "wind_gust": 3.58,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.46
//     },
//     {
//       "dt": 1624521600,
//       "temp": 296.38,
//       "feels_like": 296.53,
//       "pressure": 1010,
//       "humidity": 68,
//       "dew_point": 289.77,
//       "uvi": 1.98,
//       "clouds": 93,
//       "visibility": 10000,
//       "wind_speed": 3.37,
//       "wind_deg": 281,
//       "wind_gust": 3.06,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.38
//     },
//     {
//       "dt": 1624525200,
//       "temp": 295.95,
//       "feels_like": 296.09,
//       "pressure": 1010,
//       "humidity": 69,
//       "dew_point": 289.65,
//       "uvi": 0.77,
//       "clouds": 82,
//       "visibility": 10000,
//       "wind_speed": 2.69,
//       "wind_deg": 284,
//       "wind_gust": 2.5,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.33
//     },
//     {
//       "dt": 1624528800,
//       "temp": 295.49,
//       "feels_like": 295.61,
//       "pressure": 1010,
//       "humidity": 70,
//       "dew_point": 289.55,
//       "uvi": 0.19,
//       "clouds": 75,
//       "visibility": 10000,
//       "wind_speed": 2.6,
//       "wind_deg": 289,
//       "wind_gust": 2.85,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.39
//     },
//     {
//       "dt": 1624532400,
//       "temp": 294.73,
//       "feels_like": 294.85,
//       "pressure": 1010,
//       "humidity": 73,
//       "dew_point": 289.5,
//       "uvi": 0,
//       "clouds": 79,
//       "visibility": 10000,
//       "wind_speed": 2.43,
//       "wind_deg": 280,
//       "wind_gust": 3.09,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.39
//     },
//     {
//       "dt": 1624536000,
//       "temp": 294.35,
//       "feels_like": 294.46,
//       "pressure": 1011,
//       "humidity": 74,
//       "dew_point": 289.37,
//       "uvi": 0,
//       "clouds": 80,
//       "visibility": 10000,
//       "wind_speed": 1.72,
//       "wind_deg": 276,
//       "wind_gust": 2.35,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.42
//     },
//     {
//       "dt": 1624539600,
//       "temp": 294.2,
//       "feels_like": 294.29,
//       "pressure": 1011,
//       "humidity": 74,
//       "dew_point": 289.22,
//       "uvi": 0,
//       "clouds": 97,
//       "visibility": 10000,
//       "wind_speed": 1.03,
//       "wind_deg": 249,
//       "wind_gust": 1.22,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.25
//     },
//     {
//       "dt": 1624543200,
//       "temp": 293.99,
//       "feels_like": 294.09,
//       "pressure": 1011,
//       "humidity": 75,
//       "dew_point": 289.21,
//       "uvi": 0,
//       "clouds": 95,
//       "visibility": 10000,
//       "wind_speed": 1.06,
//       "wind_deg": 224,
//       "wind_gust": 1.2,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.17
//     },
//     {
//       "dt": 1624546800,
//       "temp": 293.69,
//       "feels_like": 293.81,
//       "pressure": 1011,
//       "humidity": 77,
//       "dew_point": 289.29,
//       "uvi": 0,
//       "clouds": 83,
//       "visibility": 10000,
//       "wind_speed": 1.47,
//       "wind_deg": 220,
//       "wind_gust": 1.81,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.08
//     },
//     {
//       "dt": 1624550400,
//       "temp": 293.35,
//       "feels_like": 293.49,
//       "pressure": 1011,
//       "humidity": 79,
//       "dew_point": 289.36,
//       "uvi": 0,
//       "clouds": 73,
//       "visibility": 10000,
//       "wind_speed": 1.24,
//       "wind_deg": 202,
//       "wind_gust": 1.59,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.08
//     },
//     {
//       "dt": 1624554000,
//       "temp": 293.1,
//       "feels_like": 293.24,
//       "pressure": 1011,
//       "humidity": 80,
//       "dew_point": 289.47,
//       "uvi": 0,
//       "clouds": 62,
//       "visibility": 10000,
//       "wind_speed": 0.83,
//       "wind_deg": 214,
//       "wind_gust": 0.99,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.07
//     },
//     {
//       "dt": 1624557600,
//       "temp": 292.89,
//       "feels_like": 293.06,
//       "pressure": 1011,
//       "humidity": 82,
//       "dew_point": 289.61,
//       "uvi": 0,
//       "clouds": 56,
//       "visibility": 10000,
//       "wind_speed": 1.26,
//       "wind_deg": 194,
//       "wind_gust": 1.48,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.02
//     },
//     {
//       "dt": 1624561200,
//       "temp": 292.61,
//       "feels_like": 292.83,
//       "pressure": 1011,
//       "humidity": 85,
//       "dew_point": 289.72,
//       "uvi": 0,
//       "clouds": 10,
//       "visibility": 10000,
//       "wind_speed": 1.31,
//       "wind_deg": 183,
//       "wind_gust": 1.54,
//       "weather": [
//         {
//           "id": 800,
//           "main": "Clear",
//           "description": "맑음",
//           "icon": "01n"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624564800,
//       "temp": 292.36,
//       "feels_like": 292.58,
//       "pressure": 1011,
//       "humidity": 86,
//       "dew_point": 289.83,
//       "uvi": 0,
//       "clouds": 37,
//       "visibility": 10000,
//       "wind_speed": 1.04,
//       "wind_deg": 164,
//       "wind_gust": 1.21,
//       "weather": [
//         {
//           "id": 802,
//           "main": "Clouds",
//           "description": "구름조금",
//           "icon": "03n"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624568400,
//       "temp": 292.58,
//       "feels_like": 292.82,
//       "pressure": 1011,
//       "humidity": 86,
//       "dew_point": 289.98,
//       "uvi": 0.13,
//       "clouds": 58,
//       "visibility": 10000,
//       "wind_speed": 0.98,
//       "wind_deg": 133,
//       "wind_gust": 1.27,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624572000,
//       "temp": 293.41,
//       "feels_like": 293.63,
//       "pressure": 1012,
//       "humidity": 82,
//       "dew_point": 290.03,
//       "uvi": 0.59,
//       "clouds": 68,
//       "visibility": 10000,
//       "wind_speed": 0.95,
//       "wind_deg": 123,
//       "wind_gust": 1.26,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624575600,
//       "temp": 294.5,
//       "feels_like": 294.68,
//       "pressure": 1012,
//       "humidity": 76,
//       "dew_point": 290.07,
//       "uvi": 1.57,
//       "clouds": 74,
//       "visibility": 10000,
//       "wind_speed": 1.06,
//       "wind_deg": 145,
//       "wind_gust": 1.45,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624579200,
//       "temp": 295.65,
//       "feels_like": 295.81,
//       "pressure": 1012,
//       "humidity": 71,
//       "dew_point": 289.99,
//       "uvi": 3.11,
//       "clouds": 79,
//       "visibility": 10000,
//       "wind_speed": 1.04,
//       "wind_deg": 196,
//       "wind_gust": 1.2,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0
//     },
//     {
//       "dt": 1624582800,
//       "temp": 296.86,
//       "feels_like": 297.01,
//       "pressure": 1011,
//       "humidity": 66,
//       "dew_point": 289.74,
//       "uvi": 4.92,
//       "clouds": 76,
//       "visibility": 10000,
//       "wind_speed": 1.68,
//       "wind_deg": 226,
//       "wind_gust": 1.72,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.14
//     },
//     {
//       "dt": 1624586400,
//       "temp": 297.6,
//       "feels_like": 297.72,
//       "pressure": 1011,
//       "humidity": 62,
//       "dew_point": 289.5,
//       "uvi": 6.57,
//       "clouds": 85,
//       "visibility": 10000,
//       "wind_speed": 2.1,
//       "wind_deg": 244,
//       "wind_gust": 1.88,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.19
//     },
//     {
//       "dt": 1624590000,
//       "temp": 297.9,
//       "feels_like": 298.02,
//       "pressure": 1010,
//       "humidity": 61,
//       "dew_point": 289.33,
//       "uvi": 7.57,
//       "clouds": 90,
//       "visibility": 10000,
//       "wind_speed": 3.13,
//       "wind_deg": 253,
//       "wind_gust": 2.65,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.23
//     },
//     {
//       "dt": 1624593600,
//       "temp": 297.89,
//       "feels_like": 297.99,
//       "pressure": 1010,
//       "humidity": 60,
//       "dew_point": 289.14,
//       "uvi": 4.94,
//       "clouds": 92,
//       "visibility": 10000,
//       "wind_speed": 3.39,
//       "wind_deg": 262,
//       "wind_gust": 2.79,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.23
//     },
//     {
//       "dt": 1624597200,
//       "temp": 297.8,
//       "feels_like": 297.89,
//       "pressure": 1009,
//       "humidity": 60,
//       "dew_point": 289.05,
//       "uvi": 4.36,
//       "clouds": 93,
//       "visibility": 10000,
//       "wind_speed": 3.51,
//       "wind_deg": 261,
//       "wind_gust": 3.11,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.23
//     },
//     {
//       "dt": 1624600800,
//       "temp": 297.77,
//       "feels_like": 297.88,
//       "pressure": 1009,
//       "humidity": 61,
//       "dew_point": 289.24,
//       "uvi": 3.33,
//       "clouds": 94,
//       "visibility": 10000,
//       "wind_speed": 3.99,
//       "wind_deg": 270,
//       "wind_gust": 3.44,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.23
//     },
//     {
//       "dt": 1624604400,
//       "temp": 297.68,
//       "feels_like": 297.81,
//       "pressure": 1009,
//       "humidity": 62,
//       "dew_point": 289.4,
//       "uvi": 1.47,
//       "clouds": 71,
//       "visibility": 10000,
//       "wind_speed": 3.62,
//       "wind_deg": 275,
//       "wind_gust": 3.22,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.28
//     },
//     {
//       "dt": 1624608000,
//       "temp": 297.3,
//       "feels_like": 297.42,
//       "pressure": 1009,
//       "humidity": 63,
//       "dew_point": 289.5,
//       "uvi": 0.77,
//       "clouds": 77,
//       "visibility": 10000,
//       "wind_speed": 3.68,
//       "wind_deg": 278,
//       "wind_gust": 3.22,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.27
//     },
//     {
//       "dt": 1624611600,
//       "temp": 296.25,
//       "feels_like": 296.37,
//       "pressure": 1009,
//       "humidity": 67,
//       "dew_point": 289.57,
//       "uvi": 0.3,
//       "clouds": 83,
//       "visibility": 10000,
//       "wind_speed": 3.74,
//       "wind_deg": 281,
//       "wind_gust": 3.97,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.27
//     },
//     {
//       "dt": 1624615200,
//       "temp": 295.43,
//       "feels_like": 295.54,
//       "pressure": 1009,
//       "humidity": 70,
//       "dew_point": 289.51,
//       "uvi": 0.05,
//       "clouds": 87,
//       "visibility": 10000,
//       "wind_speed": 2.93,
//       "wind_deg": 287,
//       "wind_gust": 3.58,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "pop": 0.23
//     },
//     {
//       "dt": 1624618800,
//       "temp": 294.92,
//       "feels_like": 295.03,
//       "pressure": 1010,
//       "humidity": 72,
//       "dew_point": 289.37,
//       "uvi": 0,
//       "clouds": 90,
//       "visibility": 10000,
//       "wind_speed": 2.07,
//       "wind_deg": 284,
//       "wind_gust": 2.61,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.23
//     },
//     {
//       "dt": 1624622400,
//       "temp": 294.64,
//       "feels_like": 294.75,
//       "pressure": 1010,
//       "humidity": 73,
//       "dew_point": 289.43,
//       "uvi": 0,
//       "clouds": 91,
//       "visibility": 10000,
//       "wind_speed": 1.36,
//       "wind_deg": 291,
//       "wind_gust": 1.85,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04n"
//         }
//       ],
//       "pop": 0.2
//     }
//   ],
//   "daily": [
//     {
//       "dt": 1624417200,
//       "sunrise": 1624392769,
//       "sunset": 1624445810,
//       "moonrise": 1624440300,
//       "moonset": 1624386540,
//       "moon_phase": 0.44,
//       "temp": {
//         "day": 297.05,
//         "min": 292.39,
//         "max": 298.42,
//         "night": 293.04,
//         "eve": 296.82,
//         "morn": 292.39
//       },
//       "feels_like": {
//         "day": 297.06,
//         "night": 293.15,
//         "eve": 296.91,
//         "morn": 292.56
//       },
//       "pressure": 1010,
//       "humidity": 60,
//       "dew_point": 288.48,
//       "wind_speed": 3.21,
//       "wind_deg": 100,
//       "wind_gust": 4.54,
//       "weather": [
//         {
//           "id": 500,
//           "main": "Rain",
//           "description": "실 비",
//           "icon": "10d"
//         }
//       ],
//       "clouds": 74,
//       "pop": 0.75,
//       "rain": 3.13,
//       "uvi": 8.11
//     },
//     {
//       "dt": 1624503600,
//       "sunrise": 1624479185,
//       "sunset": 1624532219,
//       "moonrise": 1624531140,
//       "moonset": 1624475760,
//       "moon_phase": 0.47,
//       "temp": {
//         "day": 298.08,
//         "min": 292.12,
//         "max": 298.08,
//         "night": 293.99,
//         "eve": 295.95,
//         "morn": 292.25
//       },
//       "feels_like": {
//         "day": 298.2,
//         "night": 294.09,
//         "eve": 296.09,
//         "morn": 292.46
//       },
//       "pressure": 1011,
//       "humidity": 60,
//       "dew_point": 289.34,
//       "wind_speed": 4.63,
//       "wind_deg": 262,
//       "wind_gust": 3.83,
//       "weather": [
//         {
//           "id": 803,
//           "main": "Clouds",
//           "description": "튼구름",
//           "icon": "04d"
//         }
//       ],
//       "clouds": 64,
//       "pop": 0.57,
//       "uvi": 8.72
//     },
//     {
//       "dt": 1624590000,
//       "sunrise": 1624565602,
//       "sunset": 1624618626,
//       "moonrise": 1624621560,
//       "moonset": 1624565640,
//       "moon_phase": 0.5,
//       "temp": {
//         "day": 297.9,
//         "min": 292.36,
//         "max": 297.9,
//         "night": 294.46,
//         "eve": 296.25,
//         "morn": 292.58
//       },
//       "feels_like": {
//         "day": 298.02,
//         "night": 294.58,
//         "eve": 296.37,
//         "morn": 292.82
//       },
//       "pressure": 1010,
//       "humidity": 61,
//       "dew_point": 289.33,
//       "wind_speed": 3.99,
//       "wind_deg": 270,
//       "wind_gust": 3.97,
//       "weather": [
//         {
//           "id": 804,
//           "main": "Clouds",
//           "description": "온흐림",
//           "icon": "04d"
//         }
//       ],
//       "clouds": 90,
//       "pop": 0.28,
//       "uvi": 7.57
//     },
//     {
//       "dt": 1624676400,
//       "sunrise": 1624652020,
//       "sunset": 1624705031,
//       "moonrise": 1624711380,
//       "moonset": 1624655880,
//       "moon_phase": 0.55,
//       "temp": {
//         "day": 293.34,
//         "min": 292.19,
//         "max": 294.15,
//         "night": 292.58,
//         "eve": 293.07,
//         "morn": 292.19
//       },
//       "feels_like": {
//         "day": 293.69,
//         "night": 292.95,
//         "eve": 293.47,
//         "morn": 292.6
//       },
//       "pressure": 1011,
//       "humidity": 87,
//       "dew_point": 290.99,
//       "wind_speed": 2.27,
//       "wind_deg": 261,
//       "wind_gust": 3.35,
//       "weather": [
//         {
//           "id": 500,
//           "main": "Rain",
//           "description": "실 비",
//           "icon": "10d"
//         }
//       ],
//       "clouds": 100,
//       "pop": 1,
//       "rain": 5.9,
//       "uvi": 4.1
//     },
//     {
//       "dt": 1624762800,
//       "sunrise": 1624738440,
//       "sunset": 1624791434,
//       "moonrise": 1624800540,
//       "moonset": 1624746540,
//       "moon_phase": 0.59,
//       "temp": {
//         "day": 297.25,
//         "min": 292.09,
//         "max": 299.52,
//         "night": 295.73,
//         "eve": 297.92,
//         "morn": 292.09
//       },
//       "feels_like": {
//         "day": 297.33,
//         "night": 296.03,
//         "eve": 298.07,
//         "morn": 292.31
//       },
//       "pressure": 1008,
//       "humidity": 62,
//       "dew_point": 289.23,
//       "wind_speed": 2.45,
//       "wind_deg": 75,
//       "wind_gust": 4.16,
//       "weather": [
//         {
//           "id": 500,
//           "main": "Rain",
//           "description": "실 비",
//           "icon": "10d"
//         }
//       ],
//       "clouds": 96,
//       "pop": 0.76,
//       "rain": 1.25,
//       "uvi": 5.26
//     },
//     {
//       "dt": 1624849200,
//       "sunrise": 1624824862,
//       "sunset": 1624877836,
//       "moonrise": 1624889220,
//       "moonset": 1624837080,
//       "moon_phase": 0.63,
//       "temp": {
//         "day": 299.38,
//         "min": 293.24,
//         "max": 299.38,
//         "night": 295.27,
//         "eve": 296.7,
//         "morn": 293.24
//       },
//       "feels_like": {
//         "day": 299.38,
//         "night": 295.76,
//         "eve": 297.12,
//         "morn": 293.63
//       },
//       "pressure": 1005,
//       "humidity": 61,
//       "dew_point": 290.95,
//       "wind_speed": 2.63,
//       "wind_deg": 79,
//       "wind_gust": 4.63,
//       "weather": [
//         {
//           "id": 501,
//           "main": "Rain",
//           "description": "보통 비",
//           "icon": "10d"
//         }
//       ],
//       "clouds": 26,
//       "pop": 0.94,
//       "rain": 11.61,
//       "uvi": 6
//     },
//     {
//       "dt": 1624935600,
//       "sunrise": 1624911285,
//       "sunset": 1624964236,
//       "moonrise": 1624977540,
//       "moonset": 1624927620,
//       "moon_phase": 0.66,
//       "temp": {
//         "day": 300.11,
//         "min": 293.45,
//         "max": 300.11,
//         "night": 296.08,
//         "eve": 298.17,
//         "morn": 293.45
//       },
//       "feels_like": {
//         "day": 300.91,
//         "night": 296.49,
//         "eve": 298.48,
//         "morn": 293.91
//       },
//       "pressure": 1005,
//       "humidity": 56,
//       "dew_point": 290.28,
//       "wind_speed": 2.72,
//       "wind_deg": 98,
//       "wind_gust": 4.01,
//       "weather": [
//         {
//           "id": 500,
//           "main": "Rain",
//           "description": "실 비",
//           "icon": "10d"
//         }
//       ],
//       "clouds": 11,
//       "pop": 0.83,
//       "rain": 2.02,
//       "uvi": 6
//     },
//     {
//       "dt": 1625022000,
//       "sunrise": 1624997709,
//       "sunset": 1625050634,
//       "moonrise": 0,
//       "moonset": 1625017860,
//       "moon_phase": 0.69,
//       "temp": {
//         "day": 300.49,
//         "min": 294.03,
//         "max": 300.59,
//         "night": 298.89,
//         "eve": 299.49,
//         "morn": 294.03
//       },
//       "feels_like": {
//         "day": 301.04,
//         "night": 299.11,
//         "eve": 299.49,
//         "morn": 294.29
//       },
//       "pressure": 1009,
//       "humidity": 52,
//       "dew_point": 289.4,
//       "wind_speed": 3.21,
//       "wind_deg": 107,
//       "wind_gust": 6.7,
//       "weather": [
//         {
//           "id": 500,
//           "main": "Rain",
//           "description": "실 비",
//           "icon": "10d"
//         }
//       ],
//       "clouds": 28,
//       "pop": 0.37,
//       "rain": 0.69,
//       "uvi": 6
//     }
//   ]
// }