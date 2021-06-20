import 'package:all_in_one/controllers/app.controller.dart';
import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
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
                Row(
                  children: [
                    Button(
                        text: '전체',
                        onTap: () => service.open(RouteNames.forum, arguments: {'categoryId': ''})),
                    Button(
                        text: '자유게시판',
                        onTap: () => service
                            .open(RouteNames.forum, arguments: {'categoryId': 'discussion'})),
                    Button(
                        text: '질문게시판',
                        onTap: () =>
                            service.open(RouteNames.forum, arguments: {'categoryId': 'qna'})),
                    Button(
                        text: '공지사항',
                        onTap: () =>
                            service.open(RouteNames.forum, arguments: {'categoryId': 'reminder'})),
                  ],
                ),
                Divider(),
                WidgetCollection(),
                ElevatedButton(onPressed: () => Get.toNamed(RouteNames.contact), child: Text('연락처'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
