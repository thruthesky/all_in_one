import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:widgets/widgets.dart';

class WeatherIcon extends StatefulWidget {
  WeatherIcon({this.onTap});
  final VoidCallback? onTap;
  @override
  _WeatherIconState createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  WeatherModel? data;

  late final StreamSubscription subscribe;

  String? get icon => data?.current?.weather?[0].icon;
  String get iconUrl => "https://openweathermap.org/img/wn/$icon@2x.png";
  String? get text => data?.current?.weather?[0].description;
  num? get temp => data?.current?.temp?.round();
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
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            icon == null
                ? Spinner()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.center,
                            heightFactor: 0.7,
                            widthFactor: 0.7,
                            child: CacheImage(
                              iconUrl,
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),
                      ),
                      if (temp != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(temp!.toString(), style: TextStyle(fontSize: 16)),
                            Text('℃', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      if (text != null) Text(text!, style: TextStyle(fontSize: 14)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
