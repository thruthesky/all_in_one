import 'package:country_currency_pickers/currency_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:country_currency_pickers/country_currency_pickers.dart';
import 'package:services/services.dart';

/// [onChanged] 는 defaultCountryCode 가 처음 설정될 때에도 호출된다.
class CountryPicker extends StatefulWidget {
  CountryPicker({this.defaultCountryCode = 'KR', required this.onChanged});
  final String defaultCountryCode;
  final Function onChanged;

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  late Country _selectedDialogCurrency;

  Widget _buildCurrencyDialogItem(Country country) {
    final info = countryCurrency(country.isoCode ?? '');
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Expanded(child: Text(info.koreanName)),
        SizedBox(width: 8.0),
        Text(
          "(${info.currencyKoreanName})",
          style: TextStyle(fontSize: 10, color: Colors.grey[700]),
        ),
      ],
    );
  }

  void _openCurrencyPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CurrencyPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: '검색...'),
            isSearchable: true,
            title: Text('국가 선택'),
            onValuePicked: (Country country) {
              setState(() => _selectedDialogCurrency = country);
              widget.onChanged(_selectedDialogCurrency);
            },
            itemBuilder: _buildCurrencyDialogItem,
            patchCountries: (List<Country> countries) {
              for (final c in countries) {
                final info = countryCurrency(c.isoCode ?? '');
                c.name = info.koreanName;
              }
            },
          ),
        ),
      );

  @override
  void initState() {
    super.initState();

    _selectedDialogCurrency = CountryPickerUtils.getCountryByIsoCode(widget.defaultCountryCode);
    widget.onChanged(_selectedDialogCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
            child: Text('국가 선택'),
          ),
          ListTile(
            onTap: _openCurrencyPickerDialog,
            title: _buildCurrencyDialogItem(_selectedDialogCurrency),
          ),
        ],
      ),
    );
  }
}
