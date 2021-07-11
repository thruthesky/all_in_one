import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:widgets/widgets.dart';

class AboutDisplay extends StatefulWidget {
  AboutDisplay({
    this.top,
    this.bottom,
    required this.title,
    required this.matrixVersion,
    required this.matrixUrl,
    required this.developerName,
    required this.developerContact,
    required this.developerEmail,
    required this.developerKakao,
  });
  final Widget? top;
  final Widget? bottom;
  final String title;
  final String matrixVersion;
  final String matrixUrl;
  final String developerName;
  final String developerContact;
  final String developerEmail;
  final String developerKakao;

  @override
  _AboutDisplayState createState() => _AboutDisplayState();
}

class _AboutDisplayState extends State<AboutDisplay> {
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  String platformName = '';
  String model = '';
  String machine = '';
  @override
  void initState() {
    super.initState();
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
              spaceXs,
              CenteredRow(left: Text('앱 버전 : '), right: Text('$version+$buildNumber')),
              spaceLg,
              CenteredRow(left: Text('개발자 : '), right: Text('${widget.developerName}')),
              CenteredRow(left: Text('연락처 : '), right: Text('${widget.developerContact}')),
              CenteredRow(left: Text('이메일 : '), right: Text('${widget.developerEmail}')),
              CenteredRow(left: Text('카카오톡 아이디 : '), right: Text('${widget.developerKakao}')),
              spaceLg,
              CenteredRow(left: Text('앱 패키지 명 : '), right: Text('$packageName')),
              CenteredRow(left: Text('운영체제 : '), right: Text('$platformName')),
              CenteredRow(left: Text('장치 이름 : '), right: Text('$model')),
              CenteredRow(left: Text('장치 정보 : '), right: Text('$machine')),
              CenteredRow(left: Text('Matrix 버전 : '), right: Text('${widget.matrixVersion}')),
              Text('Matrix 서버 URL : ${widget.matrixUrl}'),
            ],
          ),
        ),
        spaceSm,
        Divider(color: Colors.blue),
        spaceSm,
        if (widget.bottom != null) widget.bottom!,
      ],
    );
  }
}
