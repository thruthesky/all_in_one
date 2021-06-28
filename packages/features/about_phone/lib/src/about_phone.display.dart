import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:widgets/widgets.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  String platformName = '';
  String model = '';
  String machine = '';

  final battery = Battery();
  int level = 0;

  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<void> _initNetworkInfo() async {
    String? wifiName, wifiBSSID, wifiIP;

    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      print(e.toString());
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      print(e.toString());
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIP = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      print(e.toString());
      wifiIP = 'Failed to get Wifi IP';
    }

    setState(() {
      _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IP: $wifiIP\n';
    });
  }

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
    initPlatformState();
    _initNetworkInfo();

    init();

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

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      '보안 패치 버전': build.version.securityPatch,
      'SDK 설치 버전': build.version.sdkInt,
      '배포 버전': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      '기본 OS 버전': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      '장치명': build.device,
      '디스플레이': build.display,
      'fingerprint': build.fingerprint,
      '하드웨어': build.hardware,
      'host': build.host,
      '빌드 ID': build.id,
      '제조사': build.manufacturer,
      '모델': build.model,
      '프로덕트': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      '실제 장치': build.isPhysicalDevice,
      '안드로이드 ID': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      '장치 이름': data.name,
      '시스템 명': data.systemName,
      '시스템 버전': data.systemVersion,
      '모델': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      '실제 장치': data.isPhysicalDevice,
      'utsname.sysname': data.utsname.sysname,
      'utsname.nodename': data.utsname.nodename,
      'utsname.release': data.utsname.release,
      'utsname.version': data.utsname.version,
      'utsname.machine': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                spaceXs,
                Divider(color: Colors.blue),
                spaceXs,
                CenteredRow(
                    left: Text('배터리 상태 : '), right: Text(level >= 0 ? '$level%' : '알 수 없음')),
              ],
            ),
          ),
          spaceXs,
          Divider(color: Colors.blue),
          spaceXs,
          CenteredRow(
            left: Text('사용 중인 인터넷 : '),
            right: StreamBuilder(
                stream: Connectivity().onConnectivityChanged,
                builder: (_, snapshot) {
                  if (snapshot.hasData == false) return Text('...');

                  late String type;
                  ConnectivityResult connectivityResult = snapshot.data as dynamic;
                  if (connectivityResult == ConnectivityResult.mobile) {
                    type = "Mobile Network";
                  } else if (connectivityResult == ConnectivityResult.wifi) {
                    type = "Wifi Network";
                  } else if (connectivityResult == ConnectivityResult.none) {
                    type = "Offline";
                  } else {
                    type = 'Offline';
                  }
                  return Text(type);
                }),
          ),
          CenteredRow(
            left: Text('연결 상태 : '),
            right: Text(_connectionStatus),
          ),
          spaceXs,
          Divider(color: Colors.blue),
          spaceXs,
          if (widget.bottom != null) widget.bottom!,
          ..._deviceData.keys
              .map((String property) => CenteredRow(
                    left: Text(property + ' : '),
                    right: Text(
                      '${_deviceData[property]}',
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
