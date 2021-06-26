import 'package:all_in_one/widgets/layout.dart';
import 'package:exchange_rate/exchange_rate.dart';
import 'package:flutter/material.dart';

class ExchangeRateScreen extends StatelessWidget {
  const ExchangeRateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '환율',
      body: ExchangeRateDisplay(),
    );
  }
}
