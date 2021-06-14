import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:x_flutter/x_flutter.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class App extends GetxController {
  final box = GetStorage();
  BuildContext get context => Get.context!;

  final Api api = Api.instance;
  UserModel user = UserModel.init();

  bool get loggedIn => user.idx > 0;
  bool get notLoggedIn => !loggedIn;

  @override
  onInit() {
    super.onInit();

    /// 캐시된 사용자 정보를 읽어 초기화
    final re = box.read('user');
    if (re != null) {
      user = UserModel.fromJson(re);

      /// 먼저, 화면에 그리고
      update();

      /// 백엔드에서 최신 정보로 업데이트.
      profile();
    }
  }

  register(Map<String, dynamic> data) async {
    try {
      user = await api.user.register(data);
      setUser(user);
    } catch (e) {
      error(e);
    }
  }

  login(Map<String, dynamic> data) async {
    try {
      user = await api.user.login(data);
      setUser(user);
    } catch (e) {
      error(e);
    }
  }

  profileUpdate(Map<String, dynamic> data) async {
    try {
      user = await api.user.update(data);
      setUser(user);
    } catch (e) {
      error(e);
    }
  }

  /// 회원 정보를 가져와서 [user] 에 보관한다.
  ///
  /// 앱이 처음 부팅을 할 때, 로컬에 저장된 회원 정보를 로드하는데, 이 때, 이 함수를 한번 호출하여
  /// 백엔드의 최신 정보로 [user] 를 업데이트하고 다시 로컬에 저장한다.
  ///
  profile() async {
    api.sessionId = user.sessionId;
    try {
      user = await api.user.profile();
      setUser(user);
    } catch (e) {
      error(e);
    }
  }

  logout() {
    user = UserModel.init();
    unsetUser();
  }

  /// 회원 정보를 로컬(앱 내 저장 공간)에 저장하고, Api 에 session 정보를 지정한다.
  /// 그리고 다시 화면을 그린다.
  setUser(UserModel user) {
    box.write('user', user);
    api.sessionId = user.sessionId;
    update();
  }

  unsetUser() {
    box.remove('user');
    update();
  }

  error(e) {
    print('에러 발생: $e');
    if (!(e is String) && e.message is String) {
      alert('Assertion 에러 발생', e.message);
    } else {
      alert('에러', e);
    }
  }

  // 알림창을 띄운다
  //
  // 알림창은 예/아니오의 선택이 없다. 그래서 리턴값이 필요없다.
  Future<void> alert(String title, String content) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Get.back(result: true), child: Text('확인'))
        ],
      ),
    );
  }
}

App app = App();

class MyApp extends StatelessWidget {
  final a = Get.put(app);
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
  String version = '0.0.0';
  String time = '';

  void _getServerVersion() async {
    try {
      // 예제: 백엔드 버전 가져오기
      final res = await Api.instance.version();
      setState(() => version = res.version);
    } catch (e) {
      print("-----------> main.ts 에러: $e");
    }
  }

  void _getServerTime() async {
    try {
      // 예제: 백엔드 버전 가져오기
      final res = await Api.instance.time();
      setState(() => time = res.time);
    } catch (e) {
      print("-----------> main.ts 에러: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _getServerVersion();
    _getServerTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<App>(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Matrix server version: $version'),
              Text('Matrix server time: $time'),
              Divider(),
              if (_.notLoggedIn)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Login()),
                    Expanded(child: Register()),
                  ],
                ),
              if (_.notLoggedIn) Text('Login'),
              if (_.loggedIn) Text('회원 이름: ${_.user.name}'),
              if (_.loggedIn)
                ElevatedButton(onPressed: _.logout, child: Text('로그아웃')),
              if (_.loggedIn) Profile(),
            ],
          ),
        ),
      ),
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
                      app.login(
                          {'email': email.text, 'password': password.text});
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
                      app.register({
                        'email': email.text,
                        'password': password.text,
                        'name': name.text
                      });
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

  final name = TextEditingController(text: app.user.name);
  final address = TextEditingController(text: app.user.address);

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
                Text(app.user.email),
                SizedBox(height: 16),
                Text('사용자 이름'),
                TextField(controller: name),
                SizedBox(height: 16),
                Text('주소'),
                TextField(controller: address),
                SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                      app.profileUpdate(
                          {'name': name.text, 'address': address.text});
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
