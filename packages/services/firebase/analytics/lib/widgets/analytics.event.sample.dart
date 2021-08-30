import 'package:analytics/analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnalyticsEventSample extends StatelessWidget {
  const AnalyticsEventSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            Analytics.logAppOpen();
          },
          child: Text('logAppOpen()'),
        ),
        TextButton(
          onPressed: () {
            Analytics.logEvent(
                "xCustom_event", {'postIdx': '123', 'type': 'post', 'category': 'custom_event'});
          },
          child: Text(
              "logEvent('xCustom_event', {'postIdx': '123', 'type': 'post', 'category': 'custom_event'})"),
        ),
        TextButton(
          onPressed: () {
            Analytics.setCurrentScreen('about_us');
          },
          child: Text("setCurrentScreen('about_us')"),
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
        TextButton(
          onPressed: () {
            Analytics.logSearch(searchTerm: "custom_search");
          },
          child: Text('logSearch(searchTerm: "custom_search")'),
        ),
        TextButton(
          onPressed: () {
            Analytics.logSelectContent(contentType: 'post', itemId: '123');
          },
          child: Text("logSelectContent(contentType: 'post', itemId: '123')"),
        ),
        TextButton(
          onPressed: () {
            Analytics.logViewItem(itemId: '456', itemName: 'abc', itemCategory: 'ItemView');
          },
          child: Text("logViewItem(itemId: '456', itemName: 'abc', itemCategory: 'ItemView')"),
        ),
        TextButton(
          onPressed: () {
            Analytics.logShare(contentType: 'post', itemId: 'qwerty', method: 'facebook');
          },
          child: Text("logShare(contentType: 'post', itemId: 'qwerty', method: 'facebook')"),
        ),
        TextButton(
          onPressed: () {
            Analytics.setUserProperty(name: "level", value: "expert");
          },
          child: Text("setUserProperty(name: 'level', value: 'expert')"),
        ),
        TextButton(
          onPressed: () {
            Analytics.setUserProperty(name: "level", value: "legend");
          },
          child: Text("setUserProperty(name: 'level', value: 'legend')"),
        ),
        TextButton(
          onPressed: () {
            Analytics.setUserProperty(name: "level", value: null);
          },
          child: Text("setUserProperty(name: 'level', value: 'null')"),
        ),
      ],
    );
  }
}
