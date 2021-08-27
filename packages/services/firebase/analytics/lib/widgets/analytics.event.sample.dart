import 'package:analytics/analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyticsEventSample extends StatelessWidget {
  const AnalyticsEventSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        TextButton(
          onPressed: () {
            Analytics.logAppOpen();
          },
          child: Text('logAppOpen()'),
        ),
        TextButton(
          onPressed: () {
            Analytics.logLogin();
          },
          child: Text('logLogin()'),
        ),
        TextButton(
          onPressed: () {
            Analytics.logSignUp(signUpMethod: 'email');
          },
          child: Text('logSignUp(signUpMethod: "email")'),
        ),
      ],
    );
  }
}
