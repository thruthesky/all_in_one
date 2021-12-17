import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Confirm dialog
///
/// It displays a dialog with "Yes", "No" button for user to choose.
/// It return true on "Yes" button click. Otherwise false. Note that, false will
/// be returned on closing by backdrop.
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
