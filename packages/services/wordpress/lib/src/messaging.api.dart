import 'package:wordpress/wordpress.dart';

class MessagingApi {
  /// Singleton
  static MessagingApi? _instance;
  static MessagingApi get instance {
    if (_instance == null) {
      _instance = MessagingApi();
    }
    return _instance!;
  }

  Future<dynamic> updateToken(String token, {String topic: ""}) {
    return WordpressApi.instance.request("push-notification.updateToken", {
      'token': token,
    });
  }

  Future<dynamic> updateSubscription(String topic) {
    return WordpressApi.instance.request("push-notification.updateSubscription", {
      'topic': topic,
    });
  }
}
