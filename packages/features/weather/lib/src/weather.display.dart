import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({Key? key, required this.apiKey}) : super(key: key);

  final String apiKey;

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  WeatherModel? data;

  late final StreamSubscription subscribe;

  @override
  void initState() {
    super.initState();
    subscribe = WeatherService.instance.dataChanges
        .where((event) => event != null)
        .listen((value) => setState(() => data = value));
  }

  @override
  void dispose() {
    super.dispose();
    subscribe.cancel();
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
