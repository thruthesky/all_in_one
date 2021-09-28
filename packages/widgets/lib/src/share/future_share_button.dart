import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

typedef FutureStringCallback = Future<String> Function();

/// This is a clone of [ShareButton] that provides a callback to produce the text( or link ) lazily.
class FutureShareButton extends StatelessWidget {
  const FutureShareButton({
    Key? key,
    required this.child,
    required this.futureText,
    this.subject = '',
  }) : super(key: key);

  final Widget child;
  final String subject;
  final FutureStringCallback futureText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: child,
      ),
      onTap: () async {
        String text = await futureText();
        Share.share(text, subject: subject);
      },
    );
  }
}
