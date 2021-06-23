import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '날씨',
      body: Column(
        children: [
          WeatherDisplay(apiKey: Config.openWeatherMapApiKey),
        ],
      ),
    );
  }
}
