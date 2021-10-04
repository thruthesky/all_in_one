// import 'dart:async';

import 'package:all_in_one/screens/voice_recorder/voce_recorder_player.screen.dart';
import 'screens/voice_recorder/voice_recorder.screen.dart';
import 'screens/about_phone/about_phone.screen.dart';
import 'screens/beta/beta.screen.dart';
import 'screens/exchange_rate/exchange_rate.screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/about/about.screen.dart';
import 'screens/contact/contact.screen.dart';
import 'screens/country_info/country_info.screen.dart';
import 'screens/forum/forum.screen.dart';
import 'screens/home/home.screen.dart';
import 'screens/map/map.screen.dart';
import 'screens/memo/memo.screen.dart';
import 'screens/qr_code/qr_code.generate.screen.dart';
import 'screens/qr_code/qr_code.result.screen.dart';
import 'screens/qr_code/qr_code.scan.screen.dart';
import 'screens/user/login.screen.dart';
import 'screens/user/profile.screen.dart';
import 'screens/user/register.screen.dart';
import 'screens/weather/weather.screen.dart';
import 'screens/widget_collection/widget_collection.dart';
import 'services/config.dart';
import 'services/globals.dart';
import 'services/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  runApp(StudyApp());
}

class StudyApp extends StatefulWidget {
  @override
  _StudyAppState createState() => _StudyAppState();
}

class _StudyAppState extends State<StudyApp> {
  final a = Get.put(app);

  @override
  void initState() {
    super.initState();

    /// 날씨 초기화
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
        /// Country 전화 코드 때문에 추가
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KR'),
      ],
      locale: Locale(Get.deviceLocale!.languageCode),
      // translations: ApiTranslations(trans: {
      //   'en': {
      //     'app_name': 'Yo',
      //     'apple': 'eat apple',
      //   },
      //   'ko': {
      //     'app_name': '어이, 거기',
      //     'apple': '사과먹어',
      //   }
      // }),
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
        GetPage(name: RouteNames.qrCodeResult, page: () => QrCodeResultScreen()),
        GetPage(name: RouteNames.widgetCollection, page: () => WidgetCollectionScreen()),
        GetPage(name: RouteNames.forum, page: () => ForumScreen()),
        GetPage(name: RouteNames.contact, page: () => ContactScreen()),
        GetPage(name: RouteNames.map, page: () => MapScreen()),
        GetPage(name: RouteNames.weather, page: () => WeatherScreen()),
        GetPage(name: RouteNames.countryInfo, page: () => CountryInfoScreen()),
        GetPage(name: RouteNames.exchangeRate, page: () => ExchangeRateScreen()),
        GetPage(name: RouteNames.beta, page: () => BetaScreen()),
        GetPage(name: RouteNames.aboutPhone, page: () => AboutPhoneScreen()),
        GetPage(name: RouteNames.voiceRecorder, page: () => VoiceRecorderScreen()),
        GetPage(name: RouteNames.voiceRecorderPlayer, page: () => VoiceRecorderPlayerScreen())
      ],
    );
  }
}
