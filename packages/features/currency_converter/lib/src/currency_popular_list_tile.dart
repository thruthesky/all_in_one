import 'package:auto_size_text/auto_size_text.dart' as at;
import 'package:currency_converter/src/currency.controller.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
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
    return Container(
      padding: EdgeInsets.only(left: 8),
      color: tileColor,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Text(
            CurrencyUtils.currencyToEmoji(_.currencies[code2]),
            style: TextStyle(
              fontSize: 36,
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<CurrencyController>(
                  id: "$code2",
                  builder: (_) {
                    if (_.loadingList[code2] != null && _.loadingList[code2] == false)
                      return at.AutoSizeText(
                        '${_.currencies[_.codes[0]]!.symbol} ${_.values[0]} ${_.codes[0]} = ' +
                            ((_.currencyError[code2] == null || _.currencyError[code2] == false)
                                ? '${_.currencies[code2]!.symbol} ${_.currencyValue[code2]} $code2'
                                : ''),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                      );
                    if (_.currencyError[code2] != null && _.currencyError[code2] == true)
                      return GestureDetector(
                        child: Row(
                          children: [
                            Text(
                              'Error. Tap to Reload',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(
                              Icons.restart_alt,
                              size: 16,
                            ),
                          ],
                        ),
                        onTap: () => _.loadCurrencyList(code2),
                      );
                    if (_.loadingList[code2] == null || _.loadingList[code2] == true)
                      return Spinner(
                        size: 16,
                        valueColor: Colors.black87,
                      );
                    return SizedBox();
                  },
                ),
                Text(
                  '${_.currencies[code2]!.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.menu,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.black87,
            ),
            onPressed: () => {
              Get.dialog(
                AlertDialog(
                  title: Text('Are you sure you want to delete this currency?'),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          child: Text('Yes'),
                          onPressed: () {
                            Get.back();
                            _.onCurrencyDelete(code2);
                          }),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                        child: Text('No'),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
