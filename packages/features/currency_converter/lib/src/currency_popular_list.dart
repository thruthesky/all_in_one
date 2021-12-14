import 'package:currency_converter/src/currency.controller.dart';
import 'package:currency_converter/src/currency_popular_list_tile.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
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
                      children: [Text('Help'), Icon(Icons.info_outline)],
                    ),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          titleTextStyle: TextStyle(fontSize: 12, color: Colors.black),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Hint', style: TextStyle(fontSize: 24, color: Colors.black)),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.black87,
                                  ),
                                  Text('Tap to add new currency. (10 max)'),
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
                              Row(
                                children: [
                                  Icon(Icons.remove_circle_outline),
                                  Text('Tap to remove currency.'),
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
