import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
    print("MessagingApi.instance.init()");
    this.onNotificationPermissionDenied = onNotificationPermissionDenied;
    this.onNotificationPermissionNotDetermined = onNotificationPermissionNotDetermined;

    this.onForegroundMessage = onForegroundMessage;
    this.onMessageOpenedFromTermiated = onMessageOpenedFromTermiated;
    this.onMessageOpenedFromBackground = onMessageOpenedFromBackground;
    this._initMessaging();
  }

  /// Initialize Messaging
  _initMessaging() async {
    /// Permission request for iOS only. For Android, the permission is granted by default.
    if (kIsWeb || Platform.isIOS) {
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
    print('_initMessaging:: Getting token: $token');
    await this.saveAndSubscribeToDefaultTokens();

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      this.token = token;
      this.saveAndSubscribeToDefaultTokens();
    });

    // When ever user logs in, update the token with user Id.
    // authChanges.listen((user) {
    //   if (user == null) return;
    //   this.saveAndSubscribeToDefaultTokens();
    // });
  }

  Future<dynamic> saveToken(String token, {String topic: ""}) {
    return Api.instance.request("notification.updateToken", {
      'token': token,
      'topic': topic,
    });
  }

  Future<dynamic> saveAndSubscribeToDefaultTokens() {
    return this.saveToken(this.token, topic: this.defaultTopic);
  }

  Future<dynamic> sendMessageToTopic(dynamic data) {
    return Api.instance.request("notification.sendMessageToTopic", {'data': data});
  }

  Future<dynamic> sendMessageToTokens(dynamic data) {
    return Api.instance.request("notification.sendMessageToTokens", {'data': data});
  }

  Future<dynamic> topicSubscription(dynamic data) {
    return Api.instance.request("notification.topicSubscription", {'data': data});
  }

  ///
  /// @param data
  /// accepts [users] || [emails]
  /// - users is an array of idx or string separated by comma
  /// - emails is an array of email or string separated by comma
  /// @returns
  Future<dynamic> sendMessageToUsers(dynamic data) {
    return Api.instance.request("notification.sendMessageToUsers", {'data': data});
  }

  Future<dynamic> isSubscribedToTopic(dynamic data) {
    return Api.instance.request("notification.isSubscribedToTopic", {'data': data});
  }
}
