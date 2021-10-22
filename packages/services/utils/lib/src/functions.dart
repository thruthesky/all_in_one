import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  } else if (e.code != null && e.message != null) {
    /// 에러 객체에 code 오 message 가 있는 경우,
    /// 예를 들면, FirebaseAuthException 이 여기에 온다.
    alert('Error', "${e.message} (${e.code})");
  } else if (e?.message != null) {
    if (e.message is String) {
      alert('Assertion 에러 발생', e.message);
    }
  } else {
    alert('Error', e);
  }
}

/// Print Long String
void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((RegExpMatch match) => print(match.group(0)));
}
