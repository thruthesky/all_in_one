import 'package:currency_picker/currency_picker.dart';
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

  List<String> codes = ['USD', 'KRW'];
  List<String> values = ['1', ''];
  List<double> convert = [0, 0];

  /// The value of the input box on the top of the currency form.
  double get topValue => double.tryParse(values[0]) ?? 0;
  double topValueWith(double n) => topValue * n;

  bool showSettingsButton = false;

  @override
  void onInit() {
    super.onInit();

    if (currenciesList == null || currenciesList!.isEmpty) {
      currenciesCodes = ["AUD", "GBP", "JPY", "CNY", "CAD"];
    } else {
      currenciesCodes = currenciesList!.split(',');
    }

    for (String c in currenciesCodes) {
      currencies[c] = CurrencyService().findByCode(c);
    }

    currencies[codes[0]] = CurrencyService().findByCode(codes[0]);
    currencies[codes[1]] = CurrencyService().findByCode(codes[1]);

    loadCurrency();
  }

  toDouble(dynamic v) {
    if (v is double)
      return v;
    else if (v is int) return v.toDouble();
    return double.tryParse(v);
  }

  /// This is being called when user change the Currency (of the country).
  loadCurrency() async {
    try {
      final res = await CurrencyApi.instance.get(codes[0], codes[1]);
      print('res; $res');

      convert[0] = toDouble(res[codes[0] + '_' + codes[1]]);
      convert[1] = toDouble(res[codes[1] + '_' + codes[0]]);

      if (convert[0] > convert[1]) {
        values[0] = '1';
        values[1] = convert[0].toStringAsFixed(2);
      } else {
        values[0] = convert[1].toStringAsFixed(2);
        values[1] = '1';
      }
      // loadCurrencyList();
      if (currenciesCodes.isNotEmpty) {
        for (String code in currenciesCodes) {
          loadCurrencyList(code);
        }
      }
      update();
    } catch (e) {
      onError(e);
    }
  }

  loadCurrencyList(String code) async {
    try {
      final res = await CurrencyApi.instance.get(codes[0], code);
      currencyConvert[code] = toDouble(res[codes[0] + '_' + code]);
      currencyValue[code] = topValueWith(currencyConvert[code]!).toStringAsFixed(2);
      update([code]);
    } catch (e) {
      onError(e);
    }
  }

  computeCurrencyList() {
    for (String code in currenciesCodes) {
      currencyValue[code] = topValueWith(currencyConvert[code]!).toStringAsFixed(2);
      update([code]);
    }
  }

  compute(int i) {
    if (i == 0) {
      double v = double.tryParse(values[0]) ?? 0;
      values[1] = (convert[0] * v).toStringAsFixed(2);
      update(['value1']);
      computeCurrencyList();
    } else {
      double v = double.tryParse(values[1]) ?? 0;
      values[0] = (convert[1] * v).toStringAsFixed(2);
      update(['value0']);
    }
  }

  setState(Function ss) {
    ss();
    update();
  }

  onCurrencyAdd(Currency currency) {
    if (currenciesCodes.contains(currency.code)) {
      onError('Currency already exist');
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
      onError('Currency already exist');
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

  onShowOptionSettings() {
    showSettingsButton = !showSettingsButton;
    update();
  }
}
