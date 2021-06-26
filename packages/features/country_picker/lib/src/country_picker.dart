import 'package:flutter/material.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:country_currency_pickers/currency_picker_dialog.dart';
import 'package:services/services.dart';

class CountryPicker extends StatefulWidget {
  CountryPicker();

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  Country _selectedDialogCurrency = CountryPickerUtils.getCountryByCurrencyCode('KRW');
  Widget _buildCurrencyDialogItem(Country country) {
    Map<String, String> info = countryCurrency(country.isoCode ?? '');
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Expanded(child: Text(info['koreanName']!)),
        SizedBox(width: 8.0),
        if (info['currencyKoreanName'] != '')
          Text(
            "(${info['currencyKoreanName']!})",
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
            onValuePicked: (Country country) => setState(() => _selectedDialogCurrency = country),
            itemBuilder: _buildCurrencyDialogItem,
            patchCountries: (List<Country> countries) {
              for (final c in countries) {
                Map<String, String> info = countryCurrency(c.isoCode ?? '');
                c.name = info['koreanName'];
              }
            },
          ),
        ),
      );

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
