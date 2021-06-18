import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// [text] 에 공유 할 내용 입력. HTTP URL 등의 공유 코드.
/// [subject] 는 제목. [subject] 에 값이 주어져도, 상황에 따라 [subject] 는 사용되지 않을 수 있음.
class ShareButton extends StatelessWidget {
  const ShareButton({
    Key? key,
    required this.child,
    required this.text,
    this.subject = '',
  }) : super(key: key);

  final Widget child;
  final String subject;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: child,
      ),
      onTap: () {
        Share.share(text, subject: subject);
      },
    );
  }
}
