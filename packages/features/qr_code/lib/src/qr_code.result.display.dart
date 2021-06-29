import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:services/services.dart';

class QrCodeResultDisplay extends StatefulWidget {
  const QrCodeResultDisplay({Key? key, required this.code}) : super(key: key);

  final String code;
  @override
  _QrCodeResultDisplayState createState() => _QrCodeResultDisplayState();
}

class _QrCodeResultDisplayState extends State<QrCodeResultDisplay> {
  // null 이면, launch 상태를 모름. true 이면, launch 가능 & launch 했음. false 이면 실행 불가.
  bool? launchable;

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 100), launchCode);
  }

  launchCode() async {
    try {
      if (widget.code.startsWith('+82') || widget.code.startsWith('010')) {
        bool? res = await FlutterPhoneDirectCaller.callNumber(widget.code);
        print('res: $res');
        launchable = true;
      }
      if (await canLaunch(widget.code)) {
        launchable = true;
        await launch(widget.code);
      } else {
        setState(() => launchable = false);
      }
    } catch (e) {
      error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '스캔 결과 :',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          SizedBox(height: 8),
          Text(widget.code),
        ],
      ),
    );
  }
}
