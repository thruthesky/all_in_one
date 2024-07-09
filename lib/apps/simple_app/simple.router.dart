import 'package:all_in_one/apps/simple_app/screens/home/simple.home.screen.dart';
import 'package:all_in_one/apps/simple_app/screens/user/simple.login.screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
BuildContext get globalContext => globalNavigatorKey.currentContext!;

/// GoRouter
final simpleRouter = GoRouter(
  navigatorKey: globalNavigatorKey,
  routes: [
    GoRoute(
      path: SimpleHomeScreen.routeName,
      builder: (context, state) => const SimpleHomeScreen(),
    ),
    GoRoute(
      path: SimpleLoginScreen.routeName,
      builder: (context, state) => const SimpleLoginScreen(),
    ),
  ],
);
