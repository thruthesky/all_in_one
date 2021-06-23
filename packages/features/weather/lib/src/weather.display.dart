import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({Key? key, required this.apiKey}) : super(key: key);

  final String apiKey;

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          onPressed: () {
            WeatherService.instance.updateWeather().then((value) => print(value));
          },
          child: Text('my location')),
    );
  }
}
