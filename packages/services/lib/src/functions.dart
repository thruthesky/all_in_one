import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as S;
import 'package:get/get.dart';
import 'package:x_flutter/x_flutter.dart';

/// Get.arguments 함수를 간단하게 쓰도록 도와주는 함수
///
/// 예제) String a = getArg('a', 'apple'); // a 값이 없으면 apple 이 지정된다. 기본 값은 null.
dynamic getArg(String name, [dynamic defaultValue]) {
  return Get.arguments == null || Get.arguments[name] == null ? defaultValue : Get.arguments[name];
}

// 알림창을 띄운다
//
// 알림창은 예/아니오의 선택이 없다. 그래서 리턴값이 필요없다.
Future<void> alert(String title, String content) async {
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
    if (e == IMAGE_NOT_SELECTED) {
    } else {
      alert('에러', e);
    }
  } else if (e is S.PlatformException) {
    /// 사용자가 취소를 한 경우, 에러 표시 하지 않음.
    ///
    /// 사진 업로드 등에서, 여러 차례 취소를 한 경우.
    if (e.code == 'multiple_request') {
    } else {
      alert('에러', "${e.code}: ${e.message!}");
    }
  } else if (e.message != null && e.message is String) {
    alert('Assertion 에러 발생', e.message);
  } else {
    alert('에러', e);
  }
}
