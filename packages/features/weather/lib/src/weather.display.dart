import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/src/models/current.dart';
import 'package:weather/src/weather.functions.dart';
import 'package:weather/weather.dart';
import 'package:widgets/widgets.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({Key? key, required this.apiKey}) : super(key: key);

  final String apiKey;

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  WeatherModel? weather;

  late final StreamSubscription subscribe;

  @override
  void initState() {
    super.initState();
    subscribe = WeatherService.instance.dataChanges
        .where((event) => event != null)
        .listen((value) => setState(() => weather = value));
  }

  @override
  void dispose() {
    super.dispose();
    subscribe.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (weather == null) return Spinner();
    Current current = weather!.current!;
    String feelsLike = current.feelsLike!.round().toString();
    return Container(
      child: Row(
        children: [
          CacheImage(current.iconUrl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    current.temperature.toString(),
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('℃', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Text(
                current.description!,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '체감온도 $feelsLike',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text('°', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                ],
              ),
              Text('자외선 ' + uviText(current.uvi)),
            ],
          )
        ],
      ),
    );
  }
}
