import '../wordpress.dart';

class AppApi {
  /// Singleton
  static AppApi? _instance;
  static AppApi get instance {
    if (_instance == null) {
      _instance = AppApi();
    }
    return _instance!;
  }

  Future translations() {
    return WordpressApi.instance.request('app.translations');
  }
}
