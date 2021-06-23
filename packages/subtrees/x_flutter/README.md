# X Flutter

이 플러터 패키지는 오픈소스 백엔드인 [Matrix](https://github.com/thruthesky/centerx) 의 기능을 활용할 수 있도록 Restful Api 를 제공합니다.


# 사용법

- 기본 적인 사용법은 소스 코드의 주석으로 설명되어져 있으며 dartdoc 으로 보면 보다 편리하게 주석을 문서로 확인 할 수 있습니다.
- 또한 [Matrix](https://github.com/thruthesky/centerx) 의 API 문서를 보시면 많은 정보를 얻을 수 있습니다.

# 개발자 안내

- 플러터 공식 문서에 나오는데로 패키지 개발 작업을 진행합니다.
- 따라서, 본 패키지를 수정 또는 변경하시려면 공식 문서의 패키지 개발 부분을 읽어 보시면 좋습니다.



# 시작하기


## Api 설정

- `Api` 는 x_flutter 의 전반적인 운용을 위한 클래스로 가장 먼저, 아래와 같이 초기화를 해야 합니다. 

```dart
Api.instance.init(url: 'https://flutterkorea.com');
```

- `Api` 초기화가 되고 난 다음, 다른 서버 Api(예: 사용자 Api 클래스인 `UserApi`)클래스를 사용 할 수 있습니다.

```dart
Api.instance.init(url: 'https://flutterkorea.com'); // 먼저 초기화 하고,
UserApi.instance.name; // 사용
```


# 상태 관리 및 회원 정보 관리

- x_flutter 에서 상태 관리를 하지 않습니다. 따라서 회원이 로그인 상태인지, 로그인을 하지 않은 상태인지 알 수 없습니다.
  - 다만, 사용자 정보가 변경이 되면, `changes` 이벤트가 발생합니다. 이 이벤트르 통해서 회원이 로그인을 한 상태인지 아닌지를 알 수 있으며, 회원 정보가 변경 될 때 마다 변경된 정보를 이용 할 수 있습니다.
  - `UserChange` 위젯을 보시면, `changes` 이벤트를 통해서, 어떻게 화면에 사용자 정보를 나타내는지 또는 로그인, 로그아웃 상태에 따른 다른 정보를 화면에 나타내는지 알 수 있습니다.

- 회원이 로그인을 하면, 회원 정보를 `shared_preference` 패키지로 앱 내에 저장합니다.
  - 그리고, 앱이 재 시작할 때 앱내에 저장된 정보를 불러 들여, `changes` 이벤트를 발생하고, 서버에서 최신 정보를 가져와서 또 `changes` 이벤트를 발생합니다.
    - 이 처럼, 앱 시작시 `changes` 이벤트 4~6번 정도 발생합니다. 이 후, 회원 정보 변경이 발생 할 때마다 한번씩 이벤트가 발생합니다.


## UserChange 위젯

회원 정보가 변경(로그인, 로그아웃, 회원 가입, 회원 정보 수정 등)되면 `changes` 이벤트가 발생하는데 그 이벤트를 활용하여 만든 것이 `UserChange` 위젯입니다. 즉, `UserChange` 이벤트는 회원 정보 변경을 감지하여 원하는 내용을 화면에 나타내고자 할 때 사용하는 것입니다. 물론, 원한다면 여러분이 직접 개발해서 사용하시면 됩니다.

`loginBuilder` 는 사용자가 로그인을 했을 때, 실행되는 콜백. 로그인 시, 화면에 표시할 위젯을 빌드하면 됩니다.
`logoutBuilder` 는 사용자가 로그아웃을 했을 때, 실행되는 콜백. 로그아웃 시 또는 로그인(가입)을 하지 않은 경우, 화면에 표시할 위젯을 빌드하면 됩니다.

아래의 예제는 로그인을 했으면, 이름, 주소를 보여주고, 로그아웃 버튼을 보여줍니다. 만약, 로그인을 안했으면 로그인 또는 회원 가입 입력란을 보여줍니다.

```dart
UserChange(
  loginBuilder: (UserModel user) => Column(
    children: [
      Wrap(
        children: [
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
      Text("로그인 또는 회원 가입을 해 주세요."),
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
```

## 사진 업로드

- taxonomy, entity, code 별로 사진을 업로드합니다. 보다 자세한 사항은 소스코드에 주석이 있으므로, 주석을 참고하거나 dartdoc 으로 참고합니다.

```dart
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
```