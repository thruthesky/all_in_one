import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';
import 'package:country_currency_pickers/country_currency_pickers.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

class ExchangeRateDisplay extends StatefulWidget {
  const ExchangeRateDisplay({Key? key}) : super(key: key);

  @override
  _ExchangeRateDisplayState createState() => _ExchangeRateDisplayState();
}

class _ExchangeRateDisplayState extends State<ExchangeRateDisplay> {
  final leftAmount = TextEditingController(text: '0');
  final rightAmount = TextEditingController(text: '0');
  bool firstTimeLoadingCurrency = true;
  Map<String, dynamic>? currencies;
  Country? leftCountry;
  Country? rightCountry;

  double get leftBaseCurrency {
    if (leftCountry == null || rightCountry == null) return 0;

    String curr = rightCountry!.currencyCode! + '_' + leftCountry!.currencyCode!;
    if (currencies?[curr] == null) return 0;
    return currencies![curr];
  }

  double get rightBaseCurrency {
    if (leftCountry == null || rightCountry == null) return 0;

    String curr = leftCountry!.currencyCode! + '_' + rightCountry!.currencyCode!;
    if (currencies?[curr] == null) return 0;
    return currencies![curr];
  }

  String get leftBaseCurrencyString {
    if (leftCountry == null) return 'xxx';

    final info = countryCurrency(leftCountry!.isoCode!);

    return '1 ' + info.currencyKoreanName + '에 ';
  }

  String get rightBaseCurrencyString {
    if (rightCountry == null) return 'xxx';

    final info = countryCurrency(rightCountry!.isoCode!);
    return rightBaseCurrency.toStringAsFixed(2) + ' ' + info.currencyKoreanName + '입니다.';
  }

  String get leftSymbol {
    return countryCurrency(leftCountry?.isoCode ?? '').currencySymbol;
  }

  String get rightSymbol {
    return countryCurrency(rightCountry?.isoCode ?? '').currencySymbol;
  }

  onLeftCountryChanged(Country country) async {
    leftCountry = country;
    print('left changed ${country.currencyCode}');
    await reloadCurrency();
    compute(left: true);
  }

  onRightCountryChanged(Country country) async {
    rightCountry = country;
    print('right changed ${country.currencyCode}');
    await reloadCurrency();
    compute(right: true);
  }

  reloadCurrency() async {
    if (leftCountry == null || rightCountry == null) return;

    try {
      currencies =
          await Api.instance.currency.get(leftCountry!.currencyCode!, rightCountry!.currencyCode!);
      print('reloadCurrency; $currencies');

      if (firstTimeLoadingCurrency) {
        firstTimeLoadingCurrency = false;
        leftAmount.text = '1';
        compute(left: true);
      }

      setState(() {});
    } catch (e) {
      error(e);
    }
  }

  compute({left = false, right = false}) async {
    if (leftCountry == null || rightCountry == null) return;

    if (left) {
      if (leftAmount.text == '0' || leftAmount.text == '') {
        rightAmount.text = '';
      } else {
        rightAmount.text = (double.parse(leftAmount.text) * rightBaseCurrency).toStringAsFixed(2);
      }
    } else {
      if (rightAmount.text == '0' || rightAmount.text == '') {
        leftAmount.text = '';
      } else {
        leftAmount.text = (double.parse(rightAmount.text) * leftBaseCurrency).toStringAsFixed(2);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CountryPicker(
                  defaultCountryCode: 'US',
                  onChanged: onLeftCountryChanged,
                ),
              ),
              Expanded(
                child: CountryPicker(
                  onChanged: onRightCountryChanged,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: sm),
            child: Text(
              leftBaseCurrencyString + rightBaseCurrencyString,
              style: TextStyle(fontSize: 16),
            ),
          ),
          // CenteredRow(left: Text(leftBaseCurrencyString), right: Text(rightBaseCurrencyString)),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Row(
                    children: [
                      Text(' $leftSymbol ', style: TextStyle(fontSize: 34)),
                      Expanded(
                        child: TextField(
                          controller: leftAmount,
                          style: TextStyle(fontSize: 26),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => compute(left: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Row(
                    children: [
                      Text(' $rightSymbol ', style: TextStyle(fontSize: 34)),
                      Expanded(
                        child: TextField(
                          controller: rightAmount,
                          style: TextStyle(fontSize: 23),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => compute(right: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
