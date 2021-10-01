import '../models/user.model.dart';
import 'wordpress.api.dart';
import 'wordpress.lib.dart';

class User {
  WPUser currentUser = WPUser.fromJson({});

  /// User Singleton
  static User? _instance;
  static User get instance {
    if (_instance == null) {
      _instance = User();
    }

    return _instance!;
  }

  /// Register a new user.
  ///
  Future<WPUser> register(Json data) async {
    final res = await WordpressApi.instance.request('user.register', data);
    return WPUser.fromJson(res);
  }
}
