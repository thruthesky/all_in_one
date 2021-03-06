import 'dart:async';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordpress/wordpress.dart';

class CurrencyController extends GetxController {
  CurrencyController({
    required this.onError,
    required this.currenciesList,
    required this.onOrderChange,
  });

  final Function onError;
  final String? currenciesList;
  final Function onOrderChange;

  static CurrencyController get of => Get.find<CurrencyController>();

  Map<String, Currency?> currencies = {};

  List<String> currenciesCodes = [];
  Map<String, String> currencyValue = {};
  Map<String, double> currencyConvert = {};
  Map<String, bool> loadingList = {};
  Map<String, bool> currencyError = {};

  List<String> codes = ['USD', 'KRW'];
  List<String> values = ['1', ''];
  List<double> convert = [0, 0];
  List<bool> loader = [true, true];
  bool isCurrencyError = false;

  /// The value of the input box on the top of the currency form.
  double get topValue => double.tryParse(values[0]) ?? 0;
  double topValueWith(double n) => topValue * n;

  @override
  void onInit() {
    super.onInit();

    currencies[codes[0]] = CurrencyService().findByCode(codes[0]);
    currencies[codes[1]] = CurrencyService().findByCode(codes[1]);

    if (currenciesList == null || currenciesList!.isEmpty) {
      // currenciesCodes = ["BI", "AUD", "GBP", "JPY", "CNY", "CAD"];
      currenciesCodes = ["AUD", "GBP", "JPY", "CNY", "CAD"];
    } else {
      currenciesCodes = currenciesList!.split(',');
    }

    for (String c in currenciesCodes) {
      currencies[c] = CurrencyService().findByCode(c);
    }

    // //// test block
    // List<Currency> allCurrencies = CurrencyService().getAll();
    // // List<Currency> allCurrencies = CurrencyService().findCurrenciesByCode(['BI']);
    // // print(allCurrencies);
    // for (int i = 0; i < allCurrencies.length; i++) {
    //   currenciesCodes.add(allCurrencies[i].code);
    //   currencies[allCurrencies[i].code] = allCurrencies[i];
    // }
    // //// end test block

    loadCurrency();
  }

  toDouble(dynamic v) {
    if (v is double)
      return v;
    else if (v is int) return v.toDouble();
    return double.tryParse(v);
  }

  /// This is being called when user change the Currency (of the country).
  loadCurrency({int codeIndex = 0}) async {
    if (isCurrencyError) {
      loader[0] = true;
      loader[1] = true;
      isCurrencyError = false;
    } else if (codeIndex == 0) {
      loader[1] = true;
    } else if (codeIndex == 1) {
      loader[0] = true;
    }

    update();
    try {
      final res = await CurrencyApi.instance.get(codes[0], codes[1]);
      if (res[codes[0] + '_' + codes[1]] != null) {
        convert[0] = toDouble(res[codes[0] + '_' + codes[1]]);
        convert[1] = toDouble(res[codes[1] + '_' + codes[0]]);
        isCurrencyError = false;
      } else {
        convert[0] = 0.00;
        convert[1] = 0.00;
        isCurrencyError = true;
      }

      compute(codeIndex);
      loadList();
    } catch (e) {
      onError(e);
    }

    loader[0] = false;
    loader[1] = false;
    update();
  }

  loadList() {
    if (currenciesCodes.isNotEmpty) {
      for (String code in currenciesCodes) {
        loadCurrencyList(code);
      }
    }
  }

  loadCurrencyList(String code) async {
    loadingList[code] = true;
    currencyError[code] = false;
    update([code]);
    try {
      final res = await CurrencyApi.instance.get(codes[0], code);
      if (res[codes[0] + '_' + code] != null) {
        currencyConvert[code] = toDouble(res[codes[0] + '_' + code]);
        currencyValue[code] = topValueWith(currencyConvert[code]!).toStringAsFixed(2);
        currencyError[code] = false;
      } else {
        currencyConvert[code] = 0.00;
        currencyValue[code] = '0.00';
        currencyError[code] = true;
      }
    } catch (e) {
      currencyError[code] = true;
      onError(e);
    }

    loadingList[code] = false;
    update([code]);
  }

  computeCurrencyList() {
    for (String code in currenciesCodes) {
      if (currencyConvert[code] == null) continue;
      currencyValue[code] = topValueWith(currencyConvert[code]!).toStringAsFixed(2);
      update([code]);
    }
  }

  compute(int i, {bool reloadList = false}) {
    if (i == 0) {
      double v = double.tryParse(values[0]) ?? 0;
      values[1] = (convert[0] * v).toStringAsFixed(2);
      update(['value1']);
    } else {
      double v = double.tryParse(values[1]) ?? 0;
      values[0] = (convert[1] * v).toStringAsFixed(2);
      update(['value0']);
    }

    if (reloadList) computeCurrencyList();
  }

  setState(Function ss) {
    ss();
    update();
  }

  onCurrencyAdd(Currency currency) {
    if (currenciesCodes.contains(currency.code)) {
      Future.delayed(Duration(milliseconds: 500), () {
        Get.dialog(
          AlertDialog(
            title: Text('Currency already exist.'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Text('Close'),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        );
      });
    } else {
      currencies[currency.code] = currency;
      currenciesCodes.add(currency.code);
      loadCurrencyList(currency.code);
      onOrderChange(currenciesCodes.join(','));
    }
    update();
  }

  onChangeCurrencyList(String oldCode, Currency newCurrency) {
    if (currenciesCodes.contains(newCurrency.code)) {
      print('Currency already exist?');
      Timer(Duration(milliseconds: 500), () {
        Get.dialog(
          AlertDialog(
            title: Text('Currency already exist.'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Text('Close'),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        );
      });
    } else {
      currencies[newCurrency.code] = newCurrency;
      final i = currenciesCodes.indexOf(oldCode);
      currenciesCodes[i] = newCurrency.code;
      loadCurrencyList(newCurrency.code);
      onOrderChange(currenciesCodes.join(','));
    }
    update();
  }

  onCurrencyDelete(code) {
    final i = currenciesCodes.indexOf(code);
    currenciesCodes.removeAt(i);
    onOrderChange(currenciesCodes.join(','));
    update();
  }

  onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = currenciesCodes.removeAt(oldIndex);
    currenciesCodes.insert(newIndex, item);
    onOrderChange(currenciesCodes.join(','));
    update();
  }

  findCurrencyConvert(code) {
    return currencyConvert[code];
  }
}
