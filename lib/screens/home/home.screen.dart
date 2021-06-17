import 'package:all_in_one/controllers/app.controller.dart';
import 'package:all_in_one/services/config.dart';
import 'package:all_in_one/services/globals.dart';
import 'package:all_in_one/services/route_names.dart';
import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UploadImage(
                taxonomy: 'users',
                entity: UserApi.instance.idx,
                code: 'photoUrl',
                quality: 70,
                deletePreviousUpload: true,
                defaultChild: Text("프로필 사진 업로드"), // 업로드를 위한 기본 표시 위젯
                imageBuilder: (image) => UserAvatar(),
                // 카메라로 사진 찍어 올리기? 또는 갤러리에서 가져오기?
                choiceBuilder: (c) {
                  return Get.bottomSheet(Container(
                    color: Colors.white,
                    child: SafeArea(
                      child: Wrap(children: <Widget>[
                        ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('카메라로 사진찍어 올리기'),
                            onTap: () => Get.back(result: ImageSource.camera)),
                        ListTile(
                            leading: Icon(Icons.photo),
                            title: Text('갤러리에서 사진 가져오기'),
                            onTap: () => Get.back(result: ImageSource.gallery)),
                        ListTile(
                            leading: Icon(Icons.cancel),
                            title: Text('취소'),
                            onTap: () => Get.back()),
                      ]),
                    ),
                  ));
                },
                uploaded: (file) {
                  // [code]의 값이 `photoUrl` 이면, 사용자 프로필 사진을 업로드하는 것으로, 프로필 사진을 업로드 했으면, 사용자 정보를 다시 읽는다.
                  UserApi.instance.profile();
                  // 사진 업로드 후, 프로그레스를 진행도를 0으로 한다.
                  setState(() => p = 0);
                },
                progress: (p) => setState(() => this.p = p), // 프로그레스
                error: (e) {
                  setState(() => p = 0);
                  // 에러 표시
                  service.error(e);
                },
              ),
              LinearProgressIndicator(value: p),
              Divider(),
              Text('Matrix server version: ${_.version}'),
              Text('Matrix server time: ${_.time}'),
              Divider(),
              UserChange(
                loginBuilder: (UserModel user) => Column(children: [
                  Text('회원 이름: ${user.name}'),
                  Text('회원 주소: ${user.address}'),
                  ElevatedButton(onPressed: UserApi.instance.logout, child: Text('로그아웃')),
                  ElevatedButton(onPressed: service.openProfile, child: Text('회원 정보')),
                ]),
                logoutBuilder: (_) => Column(
                  children: [
                    ElevatedButton(onPressed: service.openRegister, child: Text('회원가입')),
                    ElevatedButton(onPressed: service.openLogin, child: Text('로그인')),
                  ],
                ),
              ),
              Text('기능별 메뉴'),
              Divider(),
              Wrap(
                spacing: xs,
                children: [
                  ElevatedButton(onPressed: service.openAbout, child: Text('어바웃 페이지')),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.memo),
                    child: Text('메모장'),
                  ),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.boni),
                    child: Text('9BONI'),
                  ),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.gyeony),
                    child: Text('gyeony'),
                  ),
                ],
              ),
              Text('잡다한 메뉴'),
              Divider(),
              ShareButton(
                text: "환상의 나라 필리핀에 오신 것을 환영합니다. https://www.philgo.com",
                child: Text('필고 사이트를 친구에게 공유 해 주세요 ^^;'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.qrCodeGenerate),
                    child: Text('QR 코드 생성'),
                  ),
                  ElevatedButton(
                    onPressed: () => service.open(RouteNames.qrCodeScan),
                    child: Text('QR 코드 스캔'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
