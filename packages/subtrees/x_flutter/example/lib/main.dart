import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

// 알림창을 띄운다
//
// 알림창은 예/아니오의 선택이 없다. 그래서 리턴값이 필요없다.
Future<void> alert(BuildContext c, String content) async {
  return showDialog(
    context: c,
    builder: (_) => AlertDialog(
      title: Text('알림'),
      content: Text(content),
    ),
  );
}

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  String version = '0.0.0';
  String time = '';

  @override
  void initState() {
    super.initState();

    Api.instance.init(url: 'https://flutterkorea.com');

    () async {
      try {
        VersionModel res = await Api.instance.version();
        setState(() => version = res.version);
        TimeModel t = await Api.instance.time();
        setState(() => time = t.time);
      } catch (e) {
        print("-----------> main.ts 에러: $e");
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Matrix server version: $version'),
            Text('Matrix server time: $time'),
            Divider(),
            UserChange(
              loginBuilder: (UserModel user) => Column(
                children: [
                  Wrap(
                    children: [
                      Text("로그인 상태!! "),
                      Text('회원 이름: ${user.name}, '),
                      Text('회원 주소: ${user.address}'),
                      ElevatedButton(onPressed: UserApi.instance.logout, child: Text('로그아웃')),
                    ],
                  ),
                  Profile()
                ],
              ),
              logoutBuilder: (_) => Column(
                children: [
                  Text("로그아웃 상태"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Login()),
                      Expanded(child: Register()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}

class Login extends StatelessWidget {
  Login({
    Key? key,
  }) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.orange[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '회원 로그인',
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.orange[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('로그인 이메일'),
                TextField(controller: email),
                SizedBox(height: 16),
                Text('로그인 비밀번호'),
                TextField(controller: password),
                SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await UserApi.instance
                            .login({'email': email.text, 'password': password.text});
                      } catch (e) {
                        alert(context, e.toString());
                      }
                    },
                    child: Text('회원 로그인'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Register extends StatelessWidget {
  Register({
    Key? key,
  }) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '회원 가입',
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('로그인 이메일'),
                TextField(controller: email),
                SizedBox(height: 16),
                Text('로그인 비밀번호'),
                TextField(controller: password),
                SizedBox(height: 16),
                Text('사용자 이름'),
                TextField(controller: name),
                SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                      UserApi.instance.register(
                          {'email': email.text, 'password': password.text, 'name': name.text});
                    },
                    child: Text('회원 가입'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Profile extends StatelessWidget {
  Profile({
    Key? key,
  }) : super(key: key);

  final name = TextEditingController(text: Api.instance.user.name);
  final address = TextEditingController(text: Api.instance.user.address);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.blueGrey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '회원 정보 수정',
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('로그인 이메일'),
                Text(Api.instance.user.email),
                SizedBox(height: 16),
                Text('사용자 이름'),
                TextField(controller: name),
                SizedBox(height: 16),
                Text('주소'),
                TextField(controller: address),
                SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await Api.instance.user
                            .update({'name': name.text, 'address': address.text});
                      } catch (e) {
                        alert(context, e.toString());
                      }
                    },
                    child: Text('회원 정보 수정'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
