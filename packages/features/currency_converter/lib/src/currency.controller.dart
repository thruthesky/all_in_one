import 'package:currency_picker/currency_picker.dart';
import 'package:get/get.dart';
import 'package:wordpress/wordpress.dart';

class CurrencyController extends GetxController {
  static CurrencyController get of => Get.find<CurrencyController>();
  Map<String, Currency?> currencies = {};

  // List<String> names = ['United States Dollar', 'Korea (South) Won'];
  List<String> codes = ['USD', 'KRW'];
  List<String> values = ['1', ''];
  List<double> convert = [0, 0];
  // List<String> symbols = ['\$', '₩'];

  /// The value of the input box on the top of the currency form.
  double get topValue => double.tryParse(values[0]) ?? 0;
  double topValueWith(double n) => topValue * n;

  final Function onError;
  CurrencyController({required this.onError});

  @override
  void onInit() {
    super.onInit();

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
      update();
    } catch (e) {
      onError(e);
    }
  }

  compute(int i) {
    if (i == 0) {
      double v = double.tryParse(values[0]) ?? 0;
      values[1] = (convert[0] * v).toStringAsFixed(2);
      update(['value1', 'list']);
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
}
