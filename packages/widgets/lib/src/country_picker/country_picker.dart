import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class CountryPciker extends StatefulWidget {
  const CountryPciker({Key? key}) : super(key: key);

  @override
  _CountryPcikerState createState() => _CountryPcikerState();
}

class _CountryPcikerState extends State<CountryPciker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: flag('kr', width: 32),
    );
  }
}
