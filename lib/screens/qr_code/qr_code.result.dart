import 'dart:async';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

/// [code] 에 스캔 값이 넘어오면,
/// - 전화번호 이면, 전화를 걸 수 있도록 알림 창이 뜬다.
/// - 그 외 실행 가능(launch 가능)한 코드(예: URL)이면 실행한다.
class QrCodeResult extends StatefulWidget {
  const QrCodeResult({Key? key}) : super(key: key);

  @override
  _QrCodeResultState createState() => _QrCodeResultState();
}

class _QrCodeResultState extends State<QrCodeResult> {
  String code = getArg('code', '');

  // null 이면, launch 상태를 모름. true 이면, launch 가능 & launch 했음. false 이면 실행 불가.
  bool? launchable;

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 100), launchCode);
  }

  launchCode() async {
    try {
      if (code.startsWith('+82') || code.startsWith('010')) {
        bool? res = await FlutterPhoneDirectCaller.callNumber(code);
        print('res: $res');
        launchable = true;
      }
      if (await canLaunch(code)) {
        launchable = true;
        await launch(code);
      } else {
        setState(() => launchable = false);
      }
    } catch (e) {
      service.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        title: 'QR 코드 스캔',
        body: Column(
          children: [
            Text('스캔 결과: $code'),
            ElevatedButton(
                onPressed: () => service.open(RouteNames.qrCodeScan),
                child: Text('다시 스캔하기'))
          ],
        ));
  }
}
