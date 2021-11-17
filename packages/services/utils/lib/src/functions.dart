import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

// import 'package:x_flutter/x_flutter.dart';

/// Get.arguments 함수를 간단하게 쓰도록 도와주는 함수
///
/// 예제) String a = getArg('a', 'apple'); // a 값이 없으면 apple 이 지정된다. 기본 값은 null.
T getArg<T>(String name, [dynamic defaultValue]) {
  return (Get.arguments == null || Get.arguments[name] == null ? defaultValue : Get.arguments[name])
      as T;
}

Future<bool> confirm(String title, String content) async {
  final re = await showDialog<bool>(
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('No'),
          )
        ],
      );
    },
  );
  if (re == true) {
    return true;
  } else {
    return false;
  }
}

// 알림창을 띄운다
//
// 알림창은 예/아니오의 선택이 없다. 그래서 리턴값이 필요없다.
Future<void> alert(String title, dynamic content) async {
  if (!(content is String)) {
    content = content.toString();
  }
  return showDialog(
    context: Get.context!,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [TextButton(onPressed: () => Get.back(result: true), child: Text('확인'))],
    ),
  );
}

/// 에러 핸들링
///
/// 모든 종류의 에러를 다 핸들링한다.
/// 따라서, 이 함수를 호출하기 전에 미리 에러가 어떤 종류의 에러인지 전처리할 필요 없이, 그냥 이 함수에 에러를 전달하면 된다.
error(e) {
  print('service.dart > 에러 발생: $e');
  if (e is String) {
    // 사진 업로드에서, 사용자가 사진을 선택하지 않은 경우, 에러 표시하지 않음.
    if (e == 'error_image_not_selected') {
    } else {
      alert('Error', e);
    }
  } else if (e is PlatformException) {
    /// 사용자가 취소를 한 경우, 에러 표시 하지 않음.
    ///
    /// 사진 업로드 등에서, 여러 차례 취소를 한 경우.
    if (e.code == 'multiple_request') {
    } else {
      alert('Error', "${e.code}: ${e.message!}");
    }
  } else if (e.runtimeType.toString() == '_TypeError') {
    final errstr = e.toString();
    if (errstr.contains('Future') && errstr.contains('is not a subtype of type')) {
      alert(
          'Await 실수', '개발자 실수입니다.\n\nFuture 에서 async 를 한 다음, await 을 하지 않았습니다.\n\n' + e.toString());
    } else {
      alert("Developer's mistake!", 'Type error: ' + e.toString());
    }
  } else if (e.runtimeType.toString() == "NoSuchMethodError") {
    if (e.toString().contains("Closure call with mismatched arguments")) {
      alert('Developer mistake...!', '클로져 함수가 받아들이는 인자 개 수와 호출 함수의 파라미터 개 수가 다릅니다.\n\n$e');
    } else {
      alert('Developer mistake.', "NoSuchMethodError; $e");
    }
  } else if (e != null && e is Map && e['code'] != null && e['message'] != null) {
    /// 에러 객체에 code 오 message 가 있는 경우,
    /// 예를 들면, FirebaseAuthException 이 여기에 온다.
    alert('Error', "${e['message']} (${e['code']})");
  } else if (e != null && e is Map && e['message'] != null) {
    if (e['message'] is String) {
      alert('Assertion error', e['message']);
    }
  } else {
    alert('Error', e.toString());
  }
}

/// Print Long String
void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((RegExpMatch match) => print(match.group(0)));
}

/// download file or data
///
/// [url] is the url to download
/// [filename] is the file name to save. If it is not set, then it will get the file name from url. The last 64 letters from the end of the url with escape.
/// [dirPath] is the directory path to save the file. if it is not set, then the file will be saved in temporary folder
/// [duration] is the time interval to download the file again
/// [onDownloadBegin], [onDownloadEnd], [onDownload] are the callback on downloda events.
Future<Uint8List> download(
  String url, {
  Duration? duration,
  String? filename,
  String? dirPath,
  Function? onDownloadBegin,
  Function? onDownloadEnd,
  Function? onDownloadProegress,
}) async {
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  String pathToSave = tempPath + '/' + 'seoul_art_exhibition7.json';

  File file = File(pathToSave);
  bool re = file.existsSync();

  if (re) {
    print('yes, downloaded file exists');
    // file exists, check if it's older than 5 days,
    DateTime now = DateTime.now();
    final Duration difference = now.difference(file.lastModifiedSync());

    print('Diff in days: ${difference.inDays}');
    if (difference.inDays > 5) {
      print('yes, downloaded file is older than 5 days');
      await _downloadUrl(url, pathToSave,
          onDownloadBegin: onDownloadBegin,
          onDownloadEnd: onDownloadEnd,
          onDownloadProegress: onDownloadProegress);
    }
  } else {
    await _downloadUrl(url, pathToSave,
        onDownloadBegin: onDownloadBegin,
        onDownloadEnd: onDownloadEnd,
        onDownloadProegress: onDownloadProegress);
  }

  file = File(pathToSave);
  re = await file.exists();

  if (re == false) {
    throw ('ERROR_FAILED_TO_LOAD_TEMPORARY_FILE');
  }

  return file.readAsBytesSync();
}

_downloadUrl(
  String url,
  String path, {
  Function? onDownloadBegin,
  Function? onDownloadEnd,
  Function? onDownloadProegress,
}) async {
  if (onDownloadBegin != null) onDownloadBegin();
  Dio dio = Dio();
  final response = await dio.get(
    url,
    onReceiveProgress: (received, total) {
      if (total != -1) {
        int p = (received / total * 100).round();
        print('download progress; $p');
      } else {
        print('download progress: total is -1');
      }
    },
    // List<int> 로 받기 위해서, 이 옵션 필수.
    // 이렇게 하지 않으면, writeFromSync() 에서 InternalLinkedHashMap<String, dynamic> is not a subtype of type List<int> 에러가 난다.
    options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
    ),
  );

  File file = File(path);

  final raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(response.data);
  raf.closeSync();

  if (onDownloadEnd != null) onDownloadEnd();
}
