import 'package:flutter/material.dart';

class ExchangeRateDisplay extends StatefulWidget {
  const ExchangeRateDisplay({Key? key}) : super(key: key);

  @override
  _ExchangeRateDisplayState createState() => _ExchangeRateDisplayState();
}

class _ExchangeRateDisplayState extends State<ExchangeRateDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Exchange Rate'),
    );
  }
}
