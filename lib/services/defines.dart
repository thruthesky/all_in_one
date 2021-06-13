import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Colors.blue;

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

const TextStyle tsWhite = TextStyle(color: Colors.white);
const TextStyle tsBlack = TextStyle(color: Colors.black);

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
