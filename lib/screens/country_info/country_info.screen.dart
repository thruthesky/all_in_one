import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:country_info/country_info.dart';

class CountryInfoScreen extends StatefulWidget {
  const CountryInfoScreen({Key? key}) : super(key: key);

  @override
  _CountryInfoScreenState createState() => _CountryInfoScreenState();
}

class _CountryInfoScreenState extends State<CountryInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '국가 별 정보',
      body: CountryInfoDisplay(),
    );
  }
}
