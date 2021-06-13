import 'package:all_in_one/screens/about/about.screen.dart';
import 'package:all_in_one/screens/home/home.screen.dart';
import 'package:all_in_one/screens/memo/memo.screen.dart';
import 'package:all_in_one/screens/user/login.screen.dart';
import 'package:all_in_one/screens/user/profile.screen.dart';
import 'package:all_in_one/screens/user/register.screen.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(AioApp());
}
var gyoeny = '수정 테스트';
class AioApp extends StatelessWidget {
  final a = Get.put(app);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '만능앱',
      defaultTransition: Transition.noTransition,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouteNames.home,
      // Get.toNamed( RouteNames.about );
      getPages: [
        GetPage(name: RouteNames.home, page: () => HomeScreen()),
        GetPage(name: RouteNames.about, page: () => AboutScreen()),
        GetPage(name: RouteNames.register, page: () => RegisterScreen()),
        GetPage(name: RouteNames.login, page: () => LoginScreen()),
        GetPage(name: RouteNames.profile, page: () => ProfileScreen()),
        GetPage(name: RouteNames.memo, page: () => MemoScreen()),
      ],
    );
  }
}
