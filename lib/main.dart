// import 'dart:async';

import 'package:all_in_one/screens/about/about.screen.dart';
import 'package:all_in_one/screens/contact/contact.screen.dart';
import 'package:all_in_one/screens/forum/forum.screen.dart';
import 'package:all_in_one/screens/home/home.screen.dart';
import 'package:all_in_one/screens/memo/memo.screen.dart';
import 'package:all_in_one/screens/qr_code/qr_code.generate.screen.dart';
import 'package:all_in_one/screens/qr_code/qr_code.result.dart';
import 'package:all_in_one/screens/qr_code/qr_code.scan.dart';
import 'package:all_in_one/screens/user/login.screen.dart';
import 'package:all_in_one/screens/user/profile.screen.dart';
import 'package:all_in_one/screens/user/register.screen.dart';
import 'package:all_in_one/screens/widget_collection/widget_collection.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:widgets/widgets.dart';

void main() async {
  await GetStorage.init();
  runApp(AioApp());
}

class AioApp extends StatefulWidget {
  @override
  _AioAppState createState() => _AioAppState();
}

class _AioAppState extends State<AioApp> {
  final a = Get.put(app);

  @override
  void initState() {
    super.initState();
    // Map<String, dynamic> m = {'idx': 2, 'name': 'JaeHo', 'subject': 'title', 'content': 'content'};
    // final post = PostModel.fromJson(m);
    // print(post);
//     () async {
// final res = await Api.instance.post.search({});
// for (final p in res) print(p);
//     }();
    // Timer(Duration(milliseconds: 100),
    //     () => service.open(RouteNames.forum, arguments: {'categoryId': 'qna'}));
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '만능앱',
      // defaultTransition: Transition.noTransition,
      theme: themeData,
      initialRoute: RouteNames.home,
      getPages: [
        GetPage(name: RouteNames.home, page: () => HomeScreen()),
        GetPage(name: RouteNames.about, page: () => AboutScreen()),
        GetPage(name: RouteNames.register, page: () => RegisterScreen()),
        GetPage(name: RouteNames.login, page: () => LoginScreen()),
        GetPage(name: RouteNames.profile, page: () => ProfileScreen()),
        GetPage(name: RouteNames.memo, page: () => MemoScreen()),
        GetPage(name: RouteNames.qrCodeGenerate, page: () => QrCodeGenerateScreen()),
        GetPage(name: RouteNames.qrCodeScan, page: () => QrCodeScanScreen()),
        GetPage(name: RouteNames.qrCodeResult, page: () => QrCodeResult()),
        GetPage(name: RouteNames.widgetCollection, page: () => WidgetCollectionScreen()),
        GetPage(name: RouteNames.forum, page: () => ForumScreen()),
        GetPage(name: RouteNames.contact, page: () => ContactScreen()),
      ],
    );
  }
}
