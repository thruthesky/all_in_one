import 'dart:io';
import 'dart:ui';

import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGenerateScreen extends StatefulWidget {
  const QrCodeGenerateScreen({Key? key}) : super(key: key);

  @override
  _QrCodeGenerateScreenState createState() => _QrCodeGenerateScreenState();
}

class _QrCodeGenerateScreenState extends State<QrCodeGenerateScreen> {
  String data = '';
  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "QR 코드 생성",
      body: Container(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'QR 문자열 입력'),
              onChanged: (text) {
                print('text: $text');
                setState(() {
                  data = text;
                });
              },
            ),
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
            ElevatedButton(
                onPressed: () async {
                  try {
                    final image = await QrPainter(
                      data: "http://www.google.com",
                      gapless: true,
                      version: QrVersions.auto,
                      color: Color.fromRGBO(0, 118, 191, 1),
                      emptyColor: Colors.white,
                    ).toImage(360);
                    final byteData = await image.toByteData(format: ImageByteFormat.png);
                    final bytes = byteData!.buffer.asUint8List();
                    final tempDir = (await getTemporaryDirectory()).path;
                    final qrcodeFile = File('$tempDir/qr_code.png');
                    await qrcodeFile.writeAsBytes(bytes);
                    print("Qr file saved: ${qrcodeFile.path}");

                    /// @todo #32 여기서 부터: QR 파일 생성 후, 사진함에 저장, 카톡으로 전송 등을 할 것.
                    qrcodeFile.delete();
                  } catch (e) {
                    service.error(e);
                  }
                },
                child: Text('QR 코드 저장하기'))
          ],
        ),
      ),
    );
  }
}
