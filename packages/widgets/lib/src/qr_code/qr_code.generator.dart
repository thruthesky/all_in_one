import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// [error] 는 필수 입력으로, 공유 버튼 클릭 후, QR 코드를 이미지로 생성하는 과정에서 에러가 있으면 호출
class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({Key? key, required this.error}) : super(key: key);

  final Function error;
  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  String data = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'QR 문자열 입력'),
            onChanged: (text) => setState(() => data = text),
          ),
          if (data == '')
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(32),
              color: Colors.indigo,
              child: Text(
                '스캔 문자열을 적어주세요.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (data != '')
            QrImage(
              data: data,
              version: QrVersions.auto,
              size: 200.0,
              errorStateBuilder: (cxt, err) {
                return Container(
                  child: Center(
                    child: Text(
                      "Uh oh! Something went wrong...",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          if (data != '')
            ElevatedButton(
                onPressed: () async {
                  try {
                    final image = await QrPainter(
                      data: data,
                      gapless: true,
                      version: QrVersions.auto,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      emptyColor: Colors.white,
                    ).toImage(360);
                    final byteData = await image.toByteData(format: ImageByteFormat.png);
                    final bytes = byteData!.buffer.asUint8List();
                    final tempDir = (await getTemporaryDirectory()).path;

                    /// 파일 명이 동일하므로, 기존의 파일을 덮어 씀. 즉, 쓰레기량이 증가하지 않음.
                    final qrcodeFile = File('$tempDir/qr_code_generator.png');
                    await qrcodeFile.writeAsBytes(bytes);
                    print("Qr file saved: ${qrcodeFile.path}");

                    Share.shareFiles([qrcodeFile.path], text: 'QR 코드: $data');

                    // 굳이 삭제 할 필요 없음.
                    // qrcodeFile.delete();
                  } catch (e) {
                    widget.error(e);
                    // service.error(e);
                  }
                },
                child: Text('QR 코드 공유하기'))
        ],
      ),
    );
  }
}
