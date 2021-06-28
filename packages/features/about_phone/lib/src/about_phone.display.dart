import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:widgets/widgets.dart';

class AboutPhoneDisplay extends StatefulWidget {
  AboutPhoneDisplay({
    this.top,
    this.bottom,
    required this.title,
  });
  final Widget? top;
  final Widget? bottom;
  final String title;

  @override
  _AboutPhoneDisplayState createState() => _AboutPhoneDisplayState();
}

class _AboutPhoneDisplayState extends State<AboutPhoneDisplay> {
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  String platformName = '';
  String model = '';
  String machine = '';

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

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      setState(() {});
    });

    () async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        platformName = '안드로이드';

        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        machine = androidInfo.device!;
        model = androidInfo.model!;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        platformName = iosInfo.systemName! + ' ' + iosInfo.systemVersion!;
        model = iosInfo.name!;

        machine = iosInfo.utsname.machine! + ' ' + iosInfo.utsname.release!;
      }
      setState(() {});
    }();
  }

  @override
  Widget build(_) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              if (widget.top != null) widget.top!,
              Text(
                widget.title,
                style: TextStyle(fontSize: 24),
              ),
              spaceLg,
              CenteredRow(left: Text('운영체제 : '), right: Text('$platformName')),
              CenteredRow(left: Text('장치 이름 : '), right: Text('$model')),
              CenteredRow(left: Text('장치 정보 : '), right: Text('$machine')),
              spaceSm,
              Divider(color: Colors.blue),
              spaceSm,
              CenteredRow(left: Text('배터리 상태 : '), right: Text(level >= 0 ? '$level%' : '알 수 없음')),
            ],
          ),
        ),
        if (widget.bottom != null) widget.bottom!,
      ],
    );
  }
}
