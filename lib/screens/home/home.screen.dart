import 'package:all_in_one/controllers/app.controller.dart';
import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double p = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (_) => Layout(
        title: Config.appName,
        body: Padding(
          padding: EdgeInsets.all(md),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('만능앱'),
                Row(
                  children: [
                    UserName(),
                    Text('님의 일상을 책임지겠습니다.'),
                  ],
                ),
                Divider(),
                WidgetCollection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
