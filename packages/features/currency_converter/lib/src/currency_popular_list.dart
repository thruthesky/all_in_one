import 'package:currency_converter/src/currency.controller.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wordpress/wordpress.dart';

class CurrencyPopularList extends StatefulWidget {
  const CurrencyPopularList({
    Key? key,
    this.currencies,
    required this.onError,
    required this.onOrderChange,
  }) : super(key: key);

  final String? currencies;

  final Function onError;
  final Function onOrderChange;

  @override
  State<CurrencyPopularList> createState() => _CurrencyPopularListState();
}

class _CurrencyPopularListState extends State<CurrencyPopularList> {
  List<String> _currencies = [];
  bool showDeleteButton = false;

  @override
  void initState() {
    super.initState();
    if (widget.currencies == null || widget.currencies!.isEmpty) {
      _currencies = ["AUD", "GBP", "JPY", "CNY", "CAD"];
    } else {
      _currencies = widget.currencies!.split(',');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Column(
      children: [
        GetBuilder<CurrencyController>(
          id: "list",
          builder: (_) {
            return ReorderableListView(
              shrinkWrap: true,
              children: [
                for (int index = 0; index < _currencies.length; index++)
                  CurrencyTile(
                    key: Key(_.codes[0] + "_" + _currencies[index] + '_' + _.values[0]),
                    value1: _.values[0],
                    code1: _.codes[0],
                    code2: _currencies[index],
                    onError: widget.onError,
                    onChangeCurrency: (oldCode, newCode) {
                      if (mounted)
                        setState(() {
                          _currencies[index] = newCode;
                        });
                      widget.onOrderChange(_currencies.join(','));
                    },
                    onDeleteCurrency: (code) {
                      setState(() {
                        final i = _currencies.indexOf(code);
                        _currencies.removeAt(i);
                      });
                      widget.onOrderChange(_currencies.join(','));
                    },
                    showDeleteButton: showDeleteButton,
                    tileColor: index.isOdd ? oddItemColor : evenItemColor,
                  )
              ],
              onReorder: (int oldIndex, int newIndex) {
                if (mounted)
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final String item = _currencies.removeAt(oldIndex);
                    _currencies.insert(newIndex, item);
                  });
                widget.onOrderChange(_currencies.join(','));
              },
            );
          },
        ),
        Row(
          children: [
            if (_currencies.length < 10)
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
                    onSelect: (Currency currency) {
                      if (_currencies.contains(currency.code)) {
                        widget.onError('Currency already exist');
                      } else {
                        if (mounted)
                          setState(() {
                            _currencies.add(currency.code);
                          });

                        widget.onOrderChange(_currencies.join(','));
                      }
                    },
                    favorite: ['USD', 'KRW'],
                  );
                },
              ),
            TextButton(
              child: Row(
                children: [
                  Text('Show Remove'),
                  Icon(Icons.remove_circle_outline),
                ],
              ),
              onPressed: () {
                setState(() {
                  this.showDeleteButton = !this.showDeleteButton;
                });
              },
            ),
          ],
        )
      ],
    );
  }
}

class CurrencyTile extends StatefulWidget {
  const CurrencyTile({
    required this.value1,
    required this.code1,
    required this.code2,
    required this.onError,
    required this.onChangeCurrency,
    required this.onDeleteCurrency,
    this.showDeleteButton = false,
    this.tileColor,
    Key? key,
  }) : super(key: key);

  final String value1;
  final String code1;
  final String code2;
  final Function onError;
  final Function(String oldCode, String newCode) onChangeCurrency;

  final Function onDeleteCurrency;

  final bool showDeleteButton;
  final Color? tileColor;

  @override
  _CurrencyTileState createState() => _CurrencyTileState();
}

class _CurrencyTileState extends State<CurrencyTile> {
  Map<String, Currency?> currencies = {};

  List<String> codes = ['', ''];
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
    currencies[widget.code1] = CurrencyService().findByCode(widget.code1);
    currencies[widget.code2] = CurrencyService().findByCode(widget.code2);
    codes[0] = widget.code1;
    codes[1] = widget.code2;
    loadCurrency();
  }

  loadCurrency() async {
    try {
      final res = await CurrencyApi.instance.get(codes[0], codes[1]);
      convert[0] = toDouble(res[codes[0] + '_' + codes[1]]);
      convert[1] = toDouble(res[codes[1] + '_' + codes[0]]);

      double v = double.tryParse(widget.value1) ?? 0;
      values[1] = (convert[0] * v).toStringAsFixed(2);

      if (mounted) setState(() {});
    } catch (e) {
      widget.onError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showCurrencyPicker(
          context: context,
          showFlag: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          onSelect: (Currency currency) {
            final tempCode = codes[1];
            setState(() {
              codes[1] = currency.code;
            });
            loadCurrency();
            widget.onChangeCurrency(tempCode, currency.code);
          },
          favorite: ['USD', 'KRW'],
        );
      },
      title: Row(
        children: [
          Text(
            CurrencyUtils.currencyToEmoji(currencies[codes[1]]),
            style: TextStyle(
              fontSize: 36,
            ),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                codes[1],
                style: TextStyle(fontSize: 20),
              ),
              Text('${currencies[codes[1]]!.name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          Spacer(),
          if (!widget.showDeleteButton)
            Text(
              '${currencies[codes[1]]!.symbol} ${values[1]}',
              style: TextStyle(fontSize: 22),
            ),
          if (widget.showDeleteButton)
            TextButton(
              child: Icon(Icons.delete_forever),
              onPressed: () {
                widget.onDeleteCurrency(codes[1]);
              },
            )
        ],
      ),
      tileColor: widget.tileColor,
    );
  }
}
