import 'package:currency_converter/src/currency.controller.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CurrencyPopularList extends StatelessWidget {
  const CurrencyPopularList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    final _ = CurrencyController.of;
    return GetBuilder<CurrencyController>(
        id: 'currency',
        builder: (_) {
          return Column(
            children: [
              ReorderableListView(
                shrinkWrap: true,
                children: [
                  for (int index = 0; index < _.currenciesCodes.length; index++)
                    CurrencyTile(
                      key: Key('currency${_.currenciesCodes[index]}'),
                      i: index,
                      code2: _.currenciesCodes[index],
                      tileColor: index.isOdd ? oddItemColor : evenItemColor,
                    )
                ],
                onReorder: _.onReorder,
              ),
              Row(
                children: [
                  if (_.currenciesCodes.length < 10)
                    TextButton(
                      child: Row(
                        children: [
                          Text('Add'),
                          Icon(
                            Icons.add_circle_outline,
                          ),
                        ],
                      ),
                      onPressed: () {
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: _.onCurrencyAdd,
                          favorite: ['USD', 'KRW'],
                        );
                      },
                    ),
                  TextButton(
                    child: Row(
                      children: [
                        Text('Settings'),
                        Icon(Icons.settings_suggest_outlined),
                      ],
                    ),
                    onPressed: _.onShowOptionSettings,
                  ),
                  TextButton(
                    child: Row(
                      children: [Text('Hint'), Icon(Icons.info_outline)],
                    ),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          titleTextStyle: TextStyle(fontSize: 12, color: Colors.black),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Hint; '),
                              Row(
                                children: [
                                  Icon(Icons.change_circle),
                                  Text('Tap on the currency to change.', softWrap: true),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.delete_forever),
                                  Text('Tap on the trash to delet.'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu,
                                    color: Colors.black87,
                                  ),
                                  Text('Long press and drag to re-order.'),
                                ],
                              ),
                            ],
                          ),
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
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class CurrencyTile extends StatelessWidget {
  CurrencyTile({
    required this.i,
    required this.code2,
    this.tileColor,
    Key? key,
  }) : super(key: key);

  final int i;
  final String code2;
  final Color? tileColor;

  final _ = CurrencyController.of;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      // onTap: () {
      //   showCurrencyPicker(
      //     context: context,
      //     showFlag: true,
      //     showCurrencyName: true,
      //     showCurrencyCode: true,
      //     onSelect: (Currency currency) {
      //       _.onChangeCurrencyList(code2, currency);
      //     },
      //     favorite: ['USD', 'KRW'],
      //   );
      // },
      title: Row(
        children: [
          Text(
            CurrencyUtils.currencyToEmoji(_.currencies[code2]),
            style: TextStyle(
              fontSize: 36,
            ),
          ),
          SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                code2,
                style: TextStyle(fontSize: 20),
              ),
              Text('${_.currencies[code2]!.name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          Spacer(),
          if (!_.showSettingsButton)
            GetBuilder<CurrencyController>(
              id: "$code2",
              builder: (_) {
                return Text(
                  '${_.currencies[code2]!.symbol} ${_.currencyValue[code2] ?? ''}',
                  style: TextStyle(fontSize: 20),
                );
              },
            ),
          if (_.showSettingsButton)
            Row(
              children: [
                PopupMenuButton(
                  icon: Icon(Icons.settings_suggest_outlined),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.change_circle),
                          Text("Change"),
                        ],
                      ),
                      value: 'change',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete_forever),
                          Text("Delete"),
                        ],
                      ),
                      value: 'delete',
                    )
                  ],
                  onSelected: (value) {
                    if (value == 'change') {
                      showCurrencyPicker(
                        context: context,
                        showFlag: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                        onSelect: (Currency currency) {
                          _.onChangeCurrencyList(code2, currency);
                        },
                        favorite: ['USD', 'KRW'],
                      );
                    } else if (value == 'delete') {
                      Get.dialog(
                        AlertDialog(
                          title: Text('Are you sure you want to delete this currency?'),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    _.onCurrencyDelete(code2);
                                  }),
                              SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                child: Text('No'),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
        ],
      ),
      tileColor: tileColor,
    );
  }
}
