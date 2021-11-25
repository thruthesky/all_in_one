import 'package:currency_converter/currency_converter.dart';
import 'package:currency_converter/src/currency.controller.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';

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
                      if (i == 0) {
                        _.loader[1] = true;
                      } else {
                        _.loader[0] = true;
                      }
                      _.loadCurrency(codeIndex: i);
                    });
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
                      _.currencies[_.codes[i]] != null
                          ? CurrencyUtils.currencyToEmoji(_.currencies[_.codes[i]]) + _.codes[i]
                          : _.codes[i],
                      style: TextStyle(fontSize: 28),
                    ),
                    if (_.currencies[_.codes[i]] != null)
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
              child: (_.loader[i])
                  ? Spinner()
                  : (_.isCurrencyError)
                      ? TextField(
                          controller: TextEditingController(text: 'Error. Tap to Reload'),
                          readOnly: true,
                          onTap: () => _.loadCurrency(),
                          style: TextStyle(fontSize: 24),
                        )
                      : TextField(
                          controller: TextEditingController(text: _.values[i]),
                          onChanged: (v) {
                            _.values[i] = v;
                            _.compute(i, reloadList: true);
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
