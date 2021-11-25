import 'package:currency_converter/src/currency.controller.dart';
import 'package:currency_converter/src/currency_popular_list_tile.dart';
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
                physics: NeverScrollableScrollPhysics(),
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
                        Text(_.showSettingsButton ? "Hide Settings" : 'Show Settings'),
                        Icon(Icons.settings_suggest_outlined),
                      ],
                    ),
                    onPressed: _.onShowOptionSettings,
                  ),
                  TextButton(
                    child: Row(
                      children: [Text('Help'), Icon(Icons.info_outline)],
                    ),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          titleTextStyle: TextStyle(fontSize: 12, color: Colors.black),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Hint'),
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
