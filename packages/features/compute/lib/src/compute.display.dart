import 'package:flutter/material.dart';

class ComputeDisplay extends StatefulWidget {
  @override
  _ComputeDisplay createState() => _ComputeDisplay();
}

class _ComputeDisplay extends State<ComputeDisplay> {
  final left = TextEditingController(text: '0');
  final right = TextEditingController(text: '0');
  num v = 0;
  compute() {
    setState(() => v = num.parse(left.text) * num.parse(right.text));
  }

  @override
  Widget build(_) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('compute display, 바나나도 먹고싶어요.'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: left,
                  onChanged: (v) => compute(),
                ),
              ),
              VerticalDivider(),
              Text(' x '),
              VerticalDivider(),
              Expanded(
                child: TextField(
                  controller: right,
                  onChanged: (v) => compute(),
                ),
              ),
              Text(' = '),
              Expanded(
                child: Text('값: $v'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
