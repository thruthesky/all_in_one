import 'package:x_flutter/x_flutter.dart';

class CurrencyApi {
  Api get api => Api.instance;

  Future<dynamic> get(String currency1, String currency2) {
    return Api.instance
        .request('currency-converter.get', {'currency1': currency1, 'currency2': currency2});
  }
}
