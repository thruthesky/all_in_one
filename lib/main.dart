import 'package:all_in_one/screens/about/about.screen.dart';
import 'package:all_in_one/screens/gyeony/gyeony.screen.dart';
import 'package:all_in_one/screens/home/home.screen.dart';
import 'package:all_in_one/screens/memo/memo.screen.dart';
<<<<<<< HEAD
import 'package:all_in_one/screens/game/game.screen.dart';
=======
import 'package:all_in_one/screens/qr_code/qr_code.generate.screen.dart';
import 'package:all_in_one/screens/qr_code/qr_code.result.dart';
import 'package:all_in_one/screens/qr_code/qr_code.scan.dart';
>>>>>>> 3b8a9a3b1f95acca94c37c1788dac29f3a09a83c
import 'package:all_in_one/screens/user/login.screen.dart';
import 'package:all_in_one/screens/user/profile.screen.dart';
import 'package:all_in_one/screens/user/register.screen.dart';
import 'package:all_in_one/screens/boni/boni.screen.dart';
import 'package:all_in_one/services/defines.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(AioApp());
}

class AioApp extends StatelessWidget {
  final a = Get.put(app);
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
        GetPage(name: RouteNames.game, page: () => GameScreen()),
        GetPage(name: RouteNames.boni, page: () => BoniScreen()),
        GetPage(name: RouteNames.gyeony, page: () => GyeonyScreen()),
        GetPage(name: RouteNames.qrCodeGenerate, page: () => QrCodeGenerateScreen()),
        GetPage(name: RouteNames.qrCodeScan, page: () => QrCodeScanScreen()),
        GetPage(name: RouteNames.qrCodeResult, page: () => QrCodeResult()),
      ],
    );
  }
}
