import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:widgets/widgets.dart';

class WeatherIcon extends StatefulWidget {
  @override
  _WeatherIconState createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  WeatherModel? data;

  late final StreamSubscription subscribe;

  String? get icon => data?.current?.weather?[0].icon;
  String get iconUrl => "https://openweathermap.org/img/wn/$icon@2x.png";
  @override
  void initState() {
    super.initState();
    subscribe = WeatherService.instance.dataChanges.listen((value) => setState(() => data = value));
  }

  @override
  void dispose() {
    super.dispose();
    subscribe.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon == null ? Spinner() : Image.network(iconUrl),
        Text('yo', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
