// import 'dart:async';

import 'package:all_in_one/screens/exchange_rate/exchange_rate.screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:all_in_one/screens/about/about.screen.dart';
import 'package:all_in_one/screens/contact/contact.screen.dart';
import 'package:all_in_one/screens/country_info/country_info.screen.dart';
import 'package:all_in_one/screens/forum/forum.screen.dart';
import 'package:all_in_one/screens/home/home.screen.dart';
import 'package:all_in_one/screens/map/map.screen.dart';
import 'package:all_in_one/screens/memo/memo.screen.dart';
import 'package:all_in_one/screens/qr_code/qr_code.generate.screen.dart';
import 'package:all_in_one/screens/qr_code/qr_code.result.dart';
import 'package:all_in_one/screens/qr_code/qr_code.scan.dart';
import 'package:all_in_one/screens/user/login.screen.dart';
import 'package:all_in_one/screens/user/profile.screen.dart';
import 'package:all_in_one/screens/user/register.screen.dart';
import 'package:all_in_one/screens/weather/weather.screen.dart';
import 'package:all_in_one/screens/widget_collection/widget_collection.dart';
import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:services/services.dart';
import 'package:weather/weather.dart';
import 'package:widgets/widgets.dart';

import 'package:country_code_picker/country_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

    WeatherService.instance.init(
      apiKey: Config.openWeatherMapApiKey, // Api key
      updateInterval: Config.openWeatherMapUpdateInterval, // 업데이트 주기
    );

    // () async {
    //   try {
    //     final re = await Api.instance.country.get(countryCode: 'KR');
    //     print(re);
    //   } catch (e) {
    //     print(e);
    //   }
    // }();

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
      localizationsDelegates: [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KR'),
      ],
      locale: Locale(Get.deviceLocale!.languageCode),
      translations: AppTranslations(trans: {
        'en': {
          'app_name': 'Yo',
          'apple': 'eat apple',
        },
        'ko': {
          'app_name': '어이, 거기',
          'apple': '사과먹어',
        }
      }),
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
        GetPage(name: RouteNames.map, page: () => MapScreen()),
        GetPage(name: RouteNames.weather, page: () => WeatherScreen()),
        GetPage(name: RouteNames.countryInfo, page: () => CountryInfoScreen()),
        GetPage(name: RouteNames.exchangeRate, page: () => ExchangeRateScreen())
      ],
    );
  }
}
