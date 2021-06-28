import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryDisplay extends StatefulWidget {
  const BatteryDisplay({Key? key}) : super(key: key);

  @override
  _BatteryDisplayState createState() => _BatteryDisplayState();
}

class _BatteryDisplayState extends State<BatteryDisplay> {
  final battery = Battery();
  int level = 0;

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
    battery.onBatteryStateChanged.listen((BatteryState state) {
      // Do something with new state
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('배터리 상태: ' + (level >= 0 ? '$level%' : '알 수 없음')),
    );
  }
}
