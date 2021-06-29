import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

/// [saved] 는 사진을 저장 했을 때, 호출되는 콜백. 옵션.
/// [shared] 는 사진을 공유 했을 때, 호출되는 콜백. 옵션.
/// [error] 콜백은 필수 입력으로, 공유 버튼 클릭 후, QR 코드를 이미지로 생성하는 과정에서 에러가 있으면 호출
class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({Key? key, required this.error, this.saved, this.shared}) : super(key: key);

  final Function error;
  final VoidCallback? saved;
  final VoidCallback? shared;
  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  String data = '';

  /// QR 코드 이미지를 로컬에 저장하고 경로를 리턴한다.
  /// 로컬 파일은 덮어쓰기를 하므로, 굳이 삭제 할 필요 없음
  Future<String> qrCodePath() async {
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
    // print("Qr file saved: ${qrcodeFile.path}");
    return qrcodeFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'QR 문자열 입력'),
              onChanged: (text) => setState(() => data = text),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      try {
                        final result = await ImageGallerySaver.saveFile(await qrCodePath());
                        if (result['isSuccess']) {
                          if (widget.saved != null) widget.saved!();
                        }
                      } catch (e) {
                        widget.error(e);
                      }
                    },
                    child: Text('저장하기'),
                  ),
                  spaceXl,
                  TextButton(
                    onPressed: () async {
                      try {
                        await Share.shareFiles([await qrCodePath()], text: 'QR 코드: $data');
                        if (widget.shared != null) widget.shared!();
                      } catch (e) {
                        widget.error(e);
                      }
                    },
                    child: Text('QR 코드 공유하기'),
                  ),
                ],
              ),
            spaceXl,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QR 생성 이용 안내',
                  style: TextStyle(color: Colors.black),
                ),
                spaceSm,
                Text(
                  '1. 먼저 QR 문자열을 입력 해 주세요.',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  '2. QR 코드를 저장하거나 공유하시면 됩니다.',
                  style: TextStyle(color: Colors.black),
                ),
                spaceSm,
                Text(
                  '팁. 전화 번호, URL 및 원하는 문자열이 무엇이든 입력하면 됩니다.',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '팁. URL 을 입력하실 때에는 http 로 시작하는 URL 전체를 입력해주세요.',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
