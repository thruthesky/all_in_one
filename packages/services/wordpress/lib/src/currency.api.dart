import '../wordpress.dart';

class CurrencyApi {
  /// Singleton
  static CurrencyApi? _instance;
  static CurrencyApi get instance {
    if (_instance == null) {
      _instance = CurrencyApi();
    }
    return _instance!;
  }

  Future<Map<String, dynamic>> get(String code1, String code2) async {
    return await WordpressApi.instance
        .request('currency.get', data: {'currency': '$code1,$code2'}, debugUrl: true);
  }

  Future<Map<String, dynamic>> getMyCurrencyAgainst(String currencyCode, String defaultCode) async {
    return await WordpressApi.instance.request('currency.getMyCurrencyAgainst', data: {
      'currency': currencyCode,
      'default': defaultCode,
    });
  }
}
