import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:x_flutter/x_flutter.dart';

class MessagingApi {
  static MessagingApi? _instance;
  static MessagingApi get instance {
    if (_instance == null) {
      _instance = MessagingApi();
    }
    return _instance!;
  }

  String token = '';
  String defaultTopic = 'defaultTopic';

  /// Event handlers on perssion state changes. for iOS only.
  /// These event will be called when permission is denied or not determined.
  Function? onNotificationPermissionDenied;
  Function? onNotificationPermissionNotDetermined;

  /// [onForegroundMessage] will be posted when there is a foreground message.
  late Function(RemoteMessage) onForegroundMessage;
  late Function onMessageOpenedFromTermiated;
  late Function onMessageOpenedFromBackground;

  init({
    required Function(RemoteMessage) onForegroundMessage,
    required Function onMessageOpenedFromTermiated,
    required Function onMessageOpenedFromBackground,
    Function? onNotificationPermissionDenied,
    Function? onNotificationPermissionNotDetermined,
  }) async {
    // print("---> MessagingApi.instance.init()");
    this.onNotificationPermissionDenied = onNotificationPermissionDenied;
    this.onNotificationPermissionNotDetermined = onNotificationPermissionNotDetermined;

    this.onForegroundMessage = onForegroundMessage;
    this.onMessageOpenedFromTermiated = onMessageOpenedFromTermiated;
    this.onMessageOpenedFromBackground = onMessageOpenedFromBackground;

    this._initMessaging();
  }

  updateBadgeCount(int count) {
    FlutterAppBadger.updateBadgeCount(count);
  }

  removeBadgeCount(int count) {
    FlutterAppBadger.removeBadge();
  }

  /// Initialize Messaging
  _initMessaging() async {
    /// Permission request for iOS only. For Android, the permission is granted by default.
    if (Platform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // print('User granted permission: ${settings.authorizationStatus}');

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          break;
        case AuthorizationStatus.denied:
          if (onNotificationPermissionDenied != null) onNotificationPermissionDenied!();
          break;
        case AuthorizationStatus.notDetermined:
          if (onNotificationPermissionNotDetermined != null)
            onNotificationPermissionNotDetermined!();
          break;
        case AuthorizationStatus.provisional:
          break;
      }
    }

    // Handler, when app is on Foreground.
    FirebaseMessaging.onMessage.listen(onForegroundMessage);

    // Check if app is opened from terminated state and get message data.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      onMessageOpenedFromTermiated(initialMessage);
    }

    // Check if the app is opened from the background state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onMessageOpenedFromBackground(message);
    });

    // Get the token each time the application loads and save it to database.
    token = (await FirebaseMessaging.instance.getToken())!;
    print('---> _initMessaging:: Getting token: $token');
    await this.saveTokenAndSubscribeToDefaultTopics();

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      this.token = token;
      this.saveTokenAndSubscribeToDefaultTopics();
    });
  }

  Future<dynamic> saveToken(String token, {String topic: ""}) {
    return Api.instance.request("notification.updateToken", {
      'token': token,
      'topic': topic,
    });
  }

  String getDefaultTopics() {
    final topic = [this.defaultTopic];
    if (Platform.isAndroid) topic.add(this.defaultTopic + 'android');
    if (Platform.isIOS) topic.add(this.defaultTopic + 'ios');
    return topic.join(',');
  }

  Future<dynamic> saveTokenAndSubscribeToDefaultTopics() {
    return this.saveToken(this.token, topic: this.getDefaultTopics());
  }

  Future<dynamic> sendMessageToTopic(dynamic data) {
    return Api.instance.request("notification.sendMessageToTopic", data);
  }

  Future<dynamic> sendMessageToTokens(dynamic data) {
    return Api.instance.request("notification.sendMessageToTokens", data);
  }

  Future<dynamic> topicSubscription(dynamic data) {
    return Api.instance.request("notification.topicSubscription", data);
  }

  Future<dynamic> subscribeOrUnsubscribeTopic(String topic) {
    return topicSubscription({'topic': topic});
  }

  ///
  /// @param data
  /// accepts [users] || [emails]
  /// - users is an array of idx or string separated by comma
  /// - emails is an array of email or string separated by comma
  /// @returns
  Future<dynamic> sendMessageToUsers(dynamic data) {
    return Api.instance.request("notification.sendMessageToUsers", data);
  }

  Future<dynamic> isSubscribedToTopic(dynamic data) {
    return Api.instance.request("notification.isSubscribedToTopic", data);
  }
}
