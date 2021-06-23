import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

@Todo('jaeho', '위젯 컬렉션을 개발자 모드에서만 볼 수 있도록 할 것.')
class WidgetCollection extends StatelessWidget {
  const WidgetCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(xl),
      child: Column(
        children: [
          Button(
            text: '만능앱',
            onTap: () => alert('만능앱', '뭐든지 할 수 있습니다!'),
          ),
          spaceSm,
          ShareButton(child: Button(text: '공유하기 버튼'), text: 'https://philgo.com'),
        ],
      ),
    );
  }
}
