import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

class UserProfileForm extends StatefulWidget {
  UserProfileForm({Key? key, required this.success, required this.error}) : super(key: key);

  final Function success;
  final Function error;

  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  double p = 0.0;
  final name = TextEditingController(text: UserApi.instance.name);
  final address = TextEditingController(text: UserApi.instance.address);

  @override
  void initState() {
    super.initState();
    UserApi.instance.profile().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UploadImage(
          taxonomy: 'users',
          entity: UserApi.instance.idx,
          code: 'photoUrl',
          quality: 70,
          deletePreviousUpload: true,
          defaultChild: Column(
            children: [
              UserAvatar(size: 100),
              spaceXs,
              Text("프로필 사진 업로드"),
            ],
          ), // 업로드를 위한 기본 표시 위젯
          imageBuilder: (image) => UserAvatar(size: 100),
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
                  ListTile(leading: Icon(Icons.cancel), title: Text('취소'), onTap: () => Get.back()),
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
            widget.error(e);
          },
        ),
        spaceSm,
        if (p > 0) ...[
          SizedBox(width: 100, child: LinearProgressIndicator(value: p)),
          spaceLg,
        ],
        Text('로그인 이메일'),
        Text(UserApi.instance.email),
        Text('포인트'),
        Text(UserApi.instance.point.toString()),
        SizedBox(height: 16),
        Text('사용자 이름'),
        TextField(controller: name),
        SizedBox(height: 16),
        Text('주소'),
        TextField(controller: address),
        SizedBox(height: 16),
        TextButton(
          onPressed: () async {
            try {
              final user =
                  await UserApi.instance.update({'name': name.text, 'address': address.text});
              widget.success(user);
            } catch (e) {
              widget.error(e);
            }
          },
          child: Text('회원 정보 수정'),
        ),
      ],
    );
  }
}
