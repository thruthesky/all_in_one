import 'package:currency_converter/src/currency.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wordpress/wordpress.dart';

class CurrencyPopularList extends StatelessWidget {
  const CurrencyPopularList({
    Key? key,
    this.currencies = "AUD,GBP,JPY,CNY,CAD",
    required this.onError,
    required this.onOrderChange,
  }) : super(key: key);

  final String currencies;

  final Function onError;
  final Function(int, int) onOrderChange;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyController>(
      builder: (_) {
        print(_);
        print(currencies);
        return ReorderableListView(
          shrinkWrap: true,
          children: [
            for (final currency in currencies.split(','))
              ListTile(
                key: ValueKey(currency),
                title: CurrencyTile(
                  code1: _.codes[0],
                  code2: currency,
                  onError: onError,
                ),
                tileColor: Colors.blue,
              ),
          ],
          onReorder: onOrderChange,
        );
      },
    );
  }
}

class CurrencyTile extends StatefulWidget {
  const CurrencyTile({
    required this.code1,
    required this.code2,
    required this.onError,
    Key? key,
  }) : super(key: key);

  final String code1;
  final String code2;
  final Function onError;

  @override
  _CurrencyTileState createState() => _CurrencyTileState();
}

class _CurrencyTileState extends State<CurrencyTile> {
  List<String> values = ['1', ''];
  List<double> convert = [0, 0];
  toDouble(dynamic v) {
    if (v is double)
      return v;
    else if (v is int) return v.toDouble();
    return double.tryParse(v);
  }

  @override
  void initState() {
    super.initState();
    loadCurrency();
  }

  loadCurrency() async {
    try {
      final res = await CurrencyApi.instance.get(widget.code1, widget.code2);
      print('res; $res');

      convert[0] = toDouble(res[widget.code1 + '_' + widget.code2]);
      convert[1] = toDouble(res[widget.code2 + '_' + widget.code1]);

      if (convert[0] > convert[1]) {
        values[0] = '1';
        values[1] = convert[0].toStringAsFixed(2);
      } else {
        values[0] = convert[1].toStringAsFixed(2);
        values[1] = '1';
      }
      setState(() {});
    } catch (e) {
      widget.onError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.code1 + ": " + values[0] + " = " + widget.code2 + ": " + values[1]),
    );
  }
}
