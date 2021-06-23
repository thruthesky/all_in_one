import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/foundation.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/qr_code.dart';

class QrCodeScanScreen extends StatelessWidget {
  const QrCodeScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'QR 코드 스캔',
      body: QrCodeScanner(
        success: (result) {
          print('포멧: ${result.format}, 코드 데이터: ${result.code}');
          service.open(RouteNames.qrCodeResult,
              arguments: {'code': result.code}, off: true);
        },
      ),
    );
  }
}
