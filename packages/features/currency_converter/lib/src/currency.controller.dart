import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wordpress/wordpress.dart';

class CurrencyController extends GetxController {
  List<String> names = ['United States Dollar', 'Korea (South) Won'];
  List<String> codes = ['USD', 'KRW'];
  List<String> values = ['1', ''];
  List<double> convert = [0, 0];
  List<String> symbols = ['\$', '₩'];

  final Function onError;
  CurrencyController({required this.onError});

  @override
  void onInit() {
    super.onInit();

    loadCurrency();
  }

  toDouble(dynamic v) {
    if (v is double)
      return v;
    else if (v is int) return v.toDouble();
    return double.tryParse(v);
  }

  loadCurrency() async {
    print("###################### loadCurrency");
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
    print('update the amount; $i');
    print('convert[0] amount; ${convert[0]}');
    print('convert[1] amount; ${convert[1]}');
    if (i == 0) {
      double v = double.tryParse(values[0]) ?? 0;
      values[1] = (convert[0] * v).toStringAsFixed(2);
      update(['value1']);
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
