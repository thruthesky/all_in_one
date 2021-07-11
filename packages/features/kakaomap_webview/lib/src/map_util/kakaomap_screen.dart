import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapScreen extends StatelessWidget {
  KakaoMapScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
          body: SafeArea(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: <JavascriptChannel>{_toasterJavascriptChannel()},
        ),
      )),
    );
  }

  JavascriptChannel _toasterJavascriptChannel() {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          _scaffoldMessengerKey.currentState
              ?.showSnackBar(SnackBar(content: Text(message.message)));
        });
  }
}
