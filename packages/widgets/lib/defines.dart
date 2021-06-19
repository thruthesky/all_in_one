import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Color primaryColor = Colors.yellow[700]!;

const Color white = Colors.white;
final Color light = Colors.grey[200]!;
final Color dark = Colors.grey[700]!;
const Color blue = Colors.blue;
const Color green = Colors.green;
const Color black = Colors.black;
const Color grey = Colors.grey;
const Color red = Colors.red;
const Color danger = Color(0xFFDD2020);
final Color warning = Colors.yellow[900]!;

const double xxs = 4;
const double xs = 8;
const double xsm = 12;
const double sm = 16;
const double md = 24;
const double lg = 32;
const double xl = 40;
const double xxl = 56;

const TextStyle tsXs = TextStyle(fontSize: 10);
const TextStyle tsSm = TextStyle(fontSize: 12);
const TextStyle tsMd = TextStyle(fontSize: 16);
const TextStyle tsLg = TextStyle(fontSize: 24);
const TextStyle tsXl = TextStyle(fontSize: 32);

const double pagePadding = xsm;

final spaceXxs = SizedBox(width: xxs, height: xxs);
final spaceXs = SizedBox(width: xs, height: xs);
final spaceXsm = SizedBox(width: xsm, height: xsm);
final spaceSm = SizedBox(width: sm, height: sm);
final spaceMd = SizedBox(width: md, height: md);
final spaceLg = SizedBox(width: lg, height: lg);
final spaceXl = SizedBox(width: xl, height: xl);
final spaceXxl = SizedBox(width: xxl, height: xxl);

TextStyle get headline1 => Theme.of(Get.context!).textTheme.headline1!; //112.0  bold,
TextStyle get headline2 => Theme.of(Get.context!).textTheme.headline2!; //56.0   normal
TextStyle get headline3 => Theme.of(Get.context!).textTheme.headline3!; //45.0   normal
TextStyle get headline4 => Theme.of(Get.context!).textTheme.headline4!; //34.0   normal
TextStyle get headline5 => Theme.of(Get.context!).textTheme.headline5!; //24.0   normal
TextStyle get headline6 => Theme.of(Get.context!).textTheme.headline6!; //20.0   normal

TextStyle get subtitle1 => Theme.of(Get.context!).textTheme.subtitle1!; //16.0
TextStyle get subtitle2 => Theme.of(Get.context!).textTheme.subtitle2!; //14.0

TextStyle get bodyText1 => Theme.of(Get.context!).textTheme.bodyText1!; //20.0,
TextStyle get bodyText2 => Theme.of(Get.context!).textTheme.bodyText2!; //16.0,

TextStyle bodyText3 = TextStyle(fontSize: 14);
TextStyle bodyText4 = TextStyle(fontSize: 12);
TextStyle bodyText5 = TextStyle(fontSize: 10);

const TextStyle tsWhite = TextStyle(color: Colors.white);
const TextStyle tsBlack = TextStyle(color: Colors.black);

// 스크린(페이지) appbar 타이틀
const TextStyle tsTitle = TextStyle(color: Colors.black, fontSize: 18);

final themeData = ThemeData(
  primarySwatch: Colors.indigo,
  // Define the default brightness and colors.
  brightness: Brightness.light,
  primaryColor: Colors.lightBlue[800],
  accentColor: Colors.cyan[600],

  // Define the default font family.
  fontFamily: 'Roboto',

  // Define the default TextTheme. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);
