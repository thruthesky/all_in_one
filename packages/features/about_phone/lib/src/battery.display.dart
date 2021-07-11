import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class BatteryDisplay extends StatefulWidget {
  const BatteryDisplay({Key? key}) : super(key: key);

  @override
  _BatteryDisplayState createState() => _BatteryDisplayState();
}

class _BatteryDisplayState extends State<BatteryDisplay> {
  final battery = Battery();
  int level = 0;
  late StreamSubscription subscription;

  init() async {
// Access current battery level

    try {
      level = await battery.batteryLevel;
    } catch (e) {
      level = -1;
      // 에러 무시
      print('배터리 에러 무시: 시뮬레이터에서는 안 나옴. $e');
    }
    setState(() {});

// Be informed when the state (full, charging, discharging) changes
    subscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
      try {
        level = await battery.batteryLevel;
        if (mounted) setState(() {});
      } on PlatformException catch (e) {
        if (e.message == 'Battery info unavailable') {}
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('배터리 상태: ' + (level >= 0 ? '$level%' : '알 수 없음')),
        SizedBox(width: 4),
        Icon(
          () {
            if (level > 80) return FontAwesome5.battery_full;
            if (level > 60) return FontAwesome5.battery_three_quarters;
            if (level > 30) return FontAwesome5.battery_half;
            if (level > 7)
              return FontAwesome5.battery_quarter;
            else
              return FontAwesome5.battery_empty;
          }(),
          color: () {
            if (level > 90) return Colors.greenAccent[700];
            if (level > 80) return Colors.green[800];
            if (level > 60) return Colors.indigoAccent;
            if (level > 30) return Colors.yellow[700];
            if (level > 10) return Colors.yellow[900];
            if (level > 7) return Colors.red[900];
            if (level > 3)
              return Colors.redAccent[700];
            else
              return Colors.grey;
          }(),
        ),
      ],
    );
  }
}
