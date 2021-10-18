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

  Future<dynamic> sendMessageToUsers({
    String title: '',
    String content: '',
    List<int>? ids,
    List<String>? emails,
    String? clickUrl,
    int? badge,
    String? sound,
    String? channel,
    MapStringDynamic? data,
  }) {
    MapStringDynamic req = {
      'title': title,
      'body': content,
      'users': ids,
      'emails': emails,
      'badge': badge,
      'click_url': clickUrl,
      'sound': sound,
      'channel': channel,
      'data': data
    };
    return WordpressApi.instance.request("push-notification.sendMessageToUsers", req);
  }
}
