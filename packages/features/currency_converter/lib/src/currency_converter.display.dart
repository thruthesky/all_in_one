import 'package:currency_converter/src/currency.controller.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:get/get.dart';
import 'package:wordpress/wordpress.dart';
import 'currency_data.dart';

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
              // ElevatedButton(onPressed: _.compute, child: Text('Exchange')),
              CurrencySelect(1),
              // Row(
              //   children: [
              //     Spacer(),
              //     TextButton(onPressed: _.compute, child: Text('Compute')),
              //   ],
              // ),
            ],
          );
        });
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
    return GetBuilder<CurrencyController>(builder: (_) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
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
                },
                favorite: ['USD', 'KRW'],
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _.codes[i],
                  style: TextStyle(fontSize: 28),
                ),
                Text('${_.symbols[i]} ${_.names[i]}', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: _.values[i]),
              onChanged: (v) {
                _.values[i] = v;
                _.compute(i);
              },
              style: TextStyle(fontSize: 28),
            ),
          ),
        ],
      );
    });
  }
}
