import 'package:currency_converter/src/currency.controller.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:get/get.dart';
// import 'package:wordpress/wordpress.dart';
// import 'currency_data.dart';

class CurrencyConverterDisplay extends StatelessWidget {
  const CurrencyConverterDisplay({required this.onError, Key? key}) : super(key: key);

  final Function onError;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyController>(
      init: CurrencyController(onError: onError),
      builder: (_) {
        return Column(
          children: [
            CurrencySelect(0),
            CurrencySelect(1),
          ],
        );
      },
    );
  }
}

class CurrencySelect extends StatelessWidget {
  const CurrencySelect(
    this.i, {
    Key? key,
  });
  final int i;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GetBuilder<CurrencyController>(builder: (_) {
          return Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () {
                showCurrencyPicker(
                  context: context,
                  showFlag: true,
                  showCurrencyName: true,
                  showCurrencyCode: true,
                  onSelect: (Currency currency) {
                    print('Select currency: ${currency.name}');
                    print(currency.code);
                    _.setState(() {
                      _.codes[i] = currency.code;
                      _.symbols[i] = currency.symbol;
                      _.names[i] = currency.name;
                    });
                    _.loadCurrency();
                  },
                  favorite: ['USD', 'KRW'],
                );
              },
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _.codes[i],
                      style: TextStyle(fontSize: 28),
                    ),
                    Text('${_.symbols[i]} ${_.names[i]}', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
          );
        }),
        SizedBox(width: 16),
        GetBuilder<CurrencyController>(
          id: "value$i",
          builder: (_) {
            return Expanded(
              flex: 3,
              child: TextField(
                controller: TextEditingController(text: _.values[i]),
                onChanged: (v) {
                  _.values[i] = v;
                  _.compute(i);
                },
                style: TextStyle(fontSize: 28),
              ),
            );
          },
        ),
      ],
    );
  }
}
