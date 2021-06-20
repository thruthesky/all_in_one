import 'package:abc/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _a = Get.put(app);
  @override
  void initState() {
    super.initState();
    Api.instance.init(url: 'https://local.sonub.com/index.php');
    print(Api.instance.url);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyName(),
            Divider(),
            UserRegisterForm(
              success: (user) {
                setState(() {});
                alert('회원 가입', '회원 가입을 하였습니다.');
              },
              error: error,
            ),
          ],
        ),
      ),
    );
  }
}
