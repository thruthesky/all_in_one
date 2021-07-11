import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:widgets/widgets.dart';

/// 날씨를 보여주는 아이콘
///
/// 만약, 날씨 정보를 가져오지 못하거나, 로딩 상태이면 [defaultChild] 를 표시 할 수 있다.
class WeatherIcon extends StatefulWidget {
  WeatherIcon({this.onTap, this.defaultChild});
  final VoidCallback? onTap;
  final Widget? defaultChild;
  @override
  _WeatherIconState createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  WeatherModel? data;

  late final StreamSubscription subscribe;

  // String? get icon => data?.current?.weather?[0].icon;
  // String get iconUrl => "https://openweathermap.org/img/wn/$icon@2x.png";
  // String? get text => data?.current?.weather?[0].description;
  // num? get temp => data?.current?.temp?.round();
  @override
  void initState() {
    super.initState();
    subscribe = WeatherService.instance.weatherChanges
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
            data?.current?.icon == null
                ? (widget.defaultChild ?? Spinner())
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
                              data!.current!.iconUrl,
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),
                      ),
                      if (data?.current?.temp != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data!.current!.temp!.round().toString(),
                                style: TextStyle(fontSize: 16)),
                            Text('℃', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      if (data?.current?.description != null)
                        Text(data!.current!.description!, style: TextStyle(fontSize: 14)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
