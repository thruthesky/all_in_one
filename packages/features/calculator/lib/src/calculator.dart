import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

class Calculator extends StatefulWidget {
  Calculator({required this.child});

  final Widget child;
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  double? _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    var calc = SimpleCalculator(
      value: _currentValue!,
      hideExpression: false,
      hideSurroundingBorder: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value;
        });
        print("$key\t$value\t$expression");
      },
      onTappedDisplay: (value, details) {
        print("$value\t${details.globalPosition}");
      },
      theme: const CalculatorThemeData(
        borderColor: Colors.black,
        borderWidth: 2,
        displayColor: Colors.black,
        displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
        expressionColor: Colors.indigo,
        expressionStyle: const TextStyle(fontSize: 20, color: Colors.white),
        operatorColor: Color(0xFFFFA111),
        operatorStyle: const TextStyle(fontSize: 30, color: Colors.white),
        commandColor: Color(0XFFC8C8C8),
        commandStyle: const TextStyle(fontSize: 30, color: Colors.black),
        numColor: Color(0xFF454545),
        numStyle: const TextStyle(fontSize: 50, color: Colors.white),
      ),
    );
    return GestureDetector(
      child: widget.child,
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return SizedBox(height: MediaQuery.of(context).size.height * 0.75, child: calc);
            });
      },
    );
  }
}
