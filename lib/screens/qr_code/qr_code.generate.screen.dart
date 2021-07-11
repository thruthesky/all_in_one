import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/qr_code.dart';

class QrCodeGenerateScreen extends StatefulWidget {
  const QrCodeGenerateScreen({Key? key}) : super(key: key);

  @override
  _QrCodeGenerateScreenState createState() => _QrCodeGenerateScreenState();
}

class _QrCodeGenerateScreenState extends State<QrCodeGenerateScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "QR 코드 생성",
      body: QrCodeGenerator(error: service.error),
    );
  }
}
