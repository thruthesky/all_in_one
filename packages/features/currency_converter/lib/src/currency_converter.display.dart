import 'package:currency_converter/currency_converter.dart';
import 'package:currency_converter/src/currency.controller.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:get/get.dart';

class CurrencyConverterDisplay extends StatelessWidget {
  const CurrencyConverterDisplay({
    required this.onError,
    required this.currenciesList,
    required this.onOrderChange,
    Key? key,
  }) : super(key: key);

  final Function onError;
  final String? currenciesList;
  final Function onOrderChange;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyController>(
      init: CurrencyController(
        currenciesList: currenciesList,
        onOrderChange: onOrderChange,
        onError: onError,
      ),
      builder: (_) {
        return Column(
          children: [
            CurrencySelect(0),
            CurrencySelect(1),
            SizedBox(height: 16),
            CurrencyPopularList(),
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
                    _.setState(() {
                      _.codes[i] = currency.code;
                      _.currencies[currency.code] = currency;
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
                      CurrencyUtils.currencyToEmoji(_.currencies[_.codes[i]]) + _.codes[i],
                      style: TextStyle(fontSize: 28),
                    ),
                    Text('${_.currencies[_.codes[i]]!.symbol} ${_.currencies[_.codes[i]]!.name}',
                        style: TextStyle(fontSize: 11)),
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
