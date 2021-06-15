import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

error(e) {
  print('service.dart > 에러 발생: $e');
  if (!(e is String) && e.message is String) {
    alert('Assertion 에러 발생', e.message);
  } else {
    alert('에러', e);
  }
}
