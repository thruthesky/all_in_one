import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/src/models/air.model.dart';
import 'package:weather/src/models/current.dart';
import 'package:weather/src/weather.functions.dart';
import 'package:weather/weather.dart';
import 'package:widgets/widgets.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({Key? key}) : super(key: key);

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WeatherDisplayMain(),
        Container(
          height: 80,
          child: VerticalDivider(
            width: 60,
            thickness: 1,
            color: Colors.grey[300],
          ),
        ),
        WeatherAirPollution(),
      ],
    );
  }
}

class WeatherAirPollution extends StatefulWidget {
  const WeatherAirPollution({Key? key}) : super(key: key);

  @override
  _WeatherAirPollutionState createState() => _WeatherAirPollutionState();
}

class _WeatherAirPollutionState extends State<WeatherAirPollution> {
  AirModel? air;

  late final StreamSubscription subscribe;

  @override
  void initState() {
    super.initState();
    subscribe = WeatherService.instance.airChanges
        .where((event) => event != null)
        .listen((value) => setState(() => air = value));
  }

  @override
  void dispose() {
    super.dispose();
    subscribe.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (air == null) return Spinner();
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.8),
              child: Text('미세먼지', style: TextStyle(fontSize: 12)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.2),
              child: Text('초 미세먼지', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        spaceXs,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.8),
              child: Text('${air?.coarseDust['text']}', style: TextStyle(fontSize: 12)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.2),
              child: Text('${air?.finDust['text']}', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        spaceXs,
        Column(
          children: [
            svg(air!.coarseDust['icon']!, width: 21.6, height: 21.6),
            spaceXs,
            svg(air!.coarseDust['icon']!, width: 21.6, height: 21.6),
          ],
        )
      ],
    )

        //  Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Row(
        //       children: [
        //         Text('미세먼지 ${air?.coarseDust['text']}', style: TextStyle(fontSize: 12)),
        //         SizedBox(width: 4),
        //         svg(air!.coarseDust['icon']!, width: 16, height: 16)
        //       ],
        //     ),
        //     Row(
        //       children: [
        //         Text('초미세먼지 ${air?.finDust['text']}', style: TextStyle(fontSize: 12)),
        //         SizedBox(width: 4),
        //         svg(air!.coarseDust['icon']!, width: 16, height: 16)
        //       ],
        //     ),
        //   ],
        // ),
        );
  }
}

class WeatherDisplayMain extends StatefulWidget {
  @override
  _WeatherDisplayMainState createState() => _WeatherDisplayMainState();
}

class _WeatherDisplayMainState extends State<WeatherDisplayMain> {
  WeatherModel? weather;
  late Current current;

  late final StreamSubscription subscribe;

  @override
  void initState() {
    super.initState();
    subscribe = WeatherService.instance.weatherChanges
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
    current = weather!.current!;
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
              // Text(
              //   current.weather![0].main!,
              //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              // ),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('자외선(UV) ' + uviText(current.uvi),
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                  SizedBox(width: 4),
                  svg(uviIcon(current.uvi), width: 16, height: 16)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
