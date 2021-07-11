import 'package:x_flutter/src/models/country.model.dart';
import 'package:x_flutter/x_flutter.dart';

class CountryApi {
  Api get api => Api.instance;

  /// 국가 정보 하나를 가져온다.
  ///
  /// 예)
  /// ```dart
  /// Api.instance.country.get(countryCode: 'KR');
  /// ```
  Future<CountryModel> get(
      {String? countryCode, String? alpha3, int? idx, String? currencyCode}) async {
    assert((countryCode ?? alpha3 ?? idx ?? currencyCode) != null, '국가 정보를 가져올 ID 정보를 입력하지 않았습니다.');
    final res = await Api.instance
        .request('country.get', {'id': countryCode ?? alpha3 ?? idx ?? currencyCode});

    return CountryModel.fromJson(res);
  }
}
