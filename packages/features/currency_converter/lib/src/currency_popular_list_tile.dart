import 'package:currency_converter/src/currency.controller.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';

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
              if (!_.showSettingsButton)
                GetBuilder<CurrencyController>(
                  id: "$code2",
                  builder: (_) {
                    return Row(
                      children: [
                        if (_.loadingList[code2] != null && _.loadingList[code2] == false)
                          Text(
                            '${_.currencies[_.codes[0]]!.symbol} ${_.values[0]} ${_.codes[0]}' +
                                " = " +
                                '${_.currencies[code2]!.symbol} ${_.currencyValue[code2]} $code2',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (_.loadingList[code2] == null || _.loadingList[code2] == true)
                          Spinner(
                            size: 16,
                            valueColor: Colors.black87,
                          ),
                      ],
                    );
                  },
                ),
              Text(
                '${_.currencies[code2]!.name}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
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
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
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
      tileColor: tileColor,
    );
  }
}
