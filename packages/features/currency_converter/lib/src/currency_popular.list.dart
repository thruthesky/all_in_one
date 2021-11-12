import 'package:flutter/widgets.dart';

class CurrencyPopularList extends StatelessWidget {
  const CurrencyPopularList({
    Key? key,
    required this.onError,
  }) : super(key: key);

  final Function onError;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Popular Currency'),
    );
  }
}
