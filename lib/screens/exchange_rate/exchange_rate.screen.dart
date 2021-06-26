import 'package:all_in_one/widgets/layout.dart';
import 'package:exchange_rate/exchange_rate.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ExchangeRateScreen extends StatelessWidget {
  const ExchangeRateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '환율',
      body: Container(
        padding: EdgeInsets.all(sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spaceXl,
            Text('국가를 선택하시면, 환율을 볼 수 있습니다.'),
            spaceSm,
            ExchangeRateDisplay(),
          ],
        ),
      ),
    );
  }
}
