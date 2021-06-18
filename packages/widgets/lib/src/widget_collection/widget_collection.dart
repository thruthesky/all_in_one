import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class WidgetCollection extends StatelessWidget {
  const WidgetCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Button(
          text: '만능앱',
          onTap: () => alert('만능앱', '뭐든지 할 수 있습니다!'),
        ),
        ShareButton(child: Text('공유하기 버튼'), text: 'https://philgo.com'),
      ],
    );
  }
}
