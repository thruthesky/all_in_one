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

    init();
  }

  init() async {
    try {
      final res = await CurrencyApi.instance.get('USD', 'KRW');
      print('res; $res');

      convert[0] = res['USD_KRW'];
      convert[1] = res['KRW_USD'];
      values[1] = convert[0].toStringAsFixed(2);
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
    } else {
      double v = double.tryParse(values[1]) ?? 0;
      values[0] = (convert[1] * v).toStringAsFixed(2);
    }

    update();
  }

  setState(Function ss) {
    ss();
    update();
  }
}
