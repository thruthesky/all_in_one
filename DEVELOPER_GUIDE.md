# 만능앱 개발자 가이드

본 문서는 만능앱 개발을 위한 개발자 문서이며, 개발 멤버들이 보다 쉽게 프로젝트 참여를 하고 성공적인 결과를 만들어내기 위해서 따라야 할 가이드라인을 제사합니다.

# 참여 인원 모집

- 프로젝트에 참여하시려는 분은 [한국 플러터 개발자 그룹](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) 단톡방에서 참여 신청을 해 주세요.
- 프로젝트에 참여하시는 분은 github 멤버로 들어와서 git repo 에 바로 액세스 할 수 있습니다.
- 문서화 작업을 도와 주실 분을 찾습니다.
  - 다른 개발자가 작성한 코드를 보고, 해당 개발자에게 소스 코드 주석을 요청하고 부족한 부분을 dartdoc 에 맞추어 작업을 하는 것입니다.
  - 특히, Restful Api 관련 코드를 문서화하는 경우 공부에 큰 도움이 되리라 생각합니다.

# 본 프로젝트(스터디) 공부해야 할 순서

- 온라인 세미나 참여
- 깃 이슈 및 프로젝트 참고
- 앱 설치 및 실행
- 편집기 설정
- 프로젝트 설정
  - launch.json
  - launch.json 에서 옵션 별로 실행하는 방법
- 개발 문서 및 dartdoc 문서 읽고, dartdoc 으로 문서화 하는 방법 확인
- 깃 브랜치를 아래의 순서로 checkout 해서 소스 코드 확인하며 익혀나가기
  - integration_test - 플러터 테스트
  - layout - 개발작업에 사용할 기본 레이아웃. 메뉴, 타이틀 바 등을 포함.
  - firebase - Android 와 iOS 에서 firebase 연동.
  - matrix - 오픈소스 백엔드 Materix 와 연동
  - user - 회원 가입 및 관리. 백엔드로 로그인을 하고 동시에 파이어베이스로 로그인.
  - social-login - 파이어베이스를 통한 구글, 페이스북, 애플 로그인. 그리고 카카오톡과 네이버 로그인
  - pass-login - 패스로그인을 통한 본인(성인 실명) 인증.
  - forum - 게시판 기능 일체. 일반적인 게시판의 모든 기능.
  - friend - 친구 관리. 블럭 사용자 관리. 블럭한 사용자의 글,코멘트,사진,추천,채팅 등을 블럭.
- 작업 후, 프로젝트 매니저에게 main 브랜치로 merge 요청

# 참고해야 할 문서

- 패키지 만들기
  - [공식문서: Flutter CLI - Developing Dart Packages](https://flutter.dev/docs/development/packages-and-plugins/developing-packages)
  - [공식문서: Creating Packages](https://dart.dev/guides/libraries/create-library-packages)

# 이슈 및 개발 작업 공간

- [Git Projects 참고](https://github.com/thruthesky/all_in_one/projects/1)

# 설치

## 만능앱 프로젝트 설치

- 플러터 최신 버전을 설치하고
- 본 프로젝트를 clone 하면 됩니다.

- git clonee 후, 본인의 이름 또는 기능별로 branch 를 생성하여, 작업을 합니다.
  - 작업을 할 때에 수시로, main 브랜치를 자신의 브랜치로 merge 해야 합니다.
  - 작업이 완료되면 본인의 브랜치를 github 로 올립니다.
    이 때, 주의 할 점은 main branch 로는 merge 할 수 없도록 되어져 있으므로 프로젝트 매니저에게 main 으로 merge 해 달라고 요청하셔야 합니다.

## Flutter 코드 개발 편집기

- 통일성 있게 `VSCode` 를 사용합니다.
- dart line length 를 100 으로 해 주세요. 기본 80 인데, 100으로 늘려서 작업을 하겠습니다.
- VSCode Better comment 플러그인을 활용합니다.
  사용하는 태그는 아래와 같습니다.
  - `@attention` (json 설정에서 강조 표시 필요)
  - `@todo`


## 스타일 가이드


- 본 프로젝트는 다트/플러터 코딩 가이드라인을 따릅니다.
  - 참고: [다트 코딩 가이드](https://dart.dev/guides/language/effective-dart/style)
  - 참고: [플러터 코딩 가이드](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
  - 이 두 문서는 다트와 플러터를 개발한 팀에서 개발자들을 위해서 마련한 표준 코딩 가이드라인이라고 보시면 됩니다. 우리는 팀멤버간에 말로 소통을 하지 않고, 서로가 작성한 소스 코드를 공유해서 교감하고 소통합니다. 그래서 각 개발자의 개성이나 취향대로 코딩를 작성해 버리면, 다른 개발자가 그 코드를 읽기 매우 어려워 집니다. 그래서 개인의 코딩 스타일을 버리고 표준을 따라야합니다.
  이것은 필수 사항이 아니며, 서로가 매일 조금씩 노력해 가면 됩니다.

- Null safety 에 많은 혼동과 올바르지 않은 사용이 예상됩니다.
  - Null safety 의 목적은 null 을 안전하게 관리하자는 것입니다.
  - 그런데 만약 변수 선언에서 `String? name` 와 같이 해 버리면, name 변수가 null 일 수 있다고 표시하는 것인데, 이렇게 하면 null safety 를 쓰는 효과가 전혀 없는 것입니다. 다시 말하면, null safety 를 사용하지도 않으면서, 억지로 null safety  적용해서 코드만 읽기 어렵게 만드는 역효과가 발생합니다.
  - 그래서 null 값이 지정될 수 있다고 표시를 하는 `물음표(?)`는 정말 어쩔 수 없는 경우에만 써야합니다.


- 코드는 짧고 간단하게
  - 코드가 길어지면, 대부분의 경우 잘못된 코드이며, 버그가 많습니다.
  - 코드가 짧아지면 짧아질수록 좋은 코드이며 버그가 적습니다.
  - 짧고 간결하게, 그리고 원하는 것을 충분히 표현하도록하는 연습을 해야 합니다.

## 문서화

- `$ dartdoc`
  - 만약, 문서화에 에러가 있으면, 플러터 폴더에 들어 있는 `dartdoc` 명령을 실행한다.
  - 예) `$HOME/bin/flutter/bin/cache/dart-sdk/bin/dartdoc --exclude 'dart:async,dart:collection,dart:convert,dart:core,dart:developer,dart:ffi,dart:html,dart:io,dart:isolate,dart:js,dart:js_util,dart:math,dart:typed_data,dart:ui'`
- `$ npm i -g http-server`
- `$ http-server doc/api`


- 본인이 작업 한 것은 반드시, 문서로 잘 남기셔야 합니다. 이것은 매우 중요합니다.
  - 문서화는 dartdoc 를 따릅니다.
    - 참고: [Dart 문서화 툴](https://pub.dev/packages/dartdoc)
    - 참고: [Dart 문서화를 잘하는 방법](https://dart.dev/guides/language/effective-dart/documentation)



## 백엔드 설치

- 백엔드는 Matrix 를 사용합니다. Matrix 는 도커 기반에 Nginx + PHP + MariaDB 로 작성된 오픈 소스입니다.
- 백엔드 설치는 Matrix 문서를 사용하면 되며,
- 직접 개발 컴퓨터에 설치해서 테스트를 해도 되고,
- 본 프로젝트를 위해서 미리 준비한 실제 서버를 사용해도 됩니다.
- Materix 에 값을 저장하고 가져오는 것, 회원, 게시판 등의 정보를 활용하는 것에 있어서 다양한 방법이 있으니, 꼭 백엔드 문서를 참고해 주세요.


# 테스트

- 테스트는 공식 문서의 Integration Test 를 진행합니다.
- 본인이 작업을 한 부분에 대해서 Integration Test 를 하면 좋습니다. 필수 사항은 아니지만, 권장합니다.


# 폴더 및 파일

- 당연히, 모든 경우에서, [다트 스타일 가이드](https://dart.dev/guides/language/effective-dart)와 [플러터 스타일 가이드](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)가 우선합니다.
- `lib/screens` 폴더에 각 기능별로 서브 폴더를 만들어 작업을 합니다.
  - 예) 회원 관련 기능은 `lib/screens/user` 폴더 아래에 모두 들어갑니다.
  - 개발 멤버가 본인이 맡은 기능을 작업하기 위해서 `lib/screens` 아래에 폴더를 만들면 됩니다.
- 각 스크린(페이지)는 `lib/screens/**/*.screen.dart` 와 같이 기록해야 하며,
  - 스크린 위젯의 이름은 파일명과 일치해야 합니다.
    - 예) 파일명이 `abc.def.screen.dart` 이면 위젯 이름은 `AbcDefScreen` 이어야 합니다.
- 위젯은 반드시 `**/widgets` 라는 폴더 아래에 기록되어야 합니다.
  - 예) `lib/screens/user/widgets/name_label.dart`
- 공유 위젯은 `lib/widgets/**/*.dart` 형태로 저장되며, 여러곳에서 활용 할 수 있는 범용성이 위젯만 이곳에 저장됩니다.
- `lib/controllers` 에는 각종 Getx 컨트롤러가 저장됩니다. 본 문서의 상태 관리를 참고하세요.
- 각종 임시 파일은 `lib/tmp/**/*` 에 저장하면 됩니다.
  - 예) `lib/tmp/json/user.json`


# 실행 및 개발 설정

- launch.json 에 실행 설정을 해야 한다면, 가능한 다음의 포멧을 따르세요.
  - `name` 에는 "개발자이름 - 장치 타입 및 버전 - 개발컴퓨터(또는 위치) - 서버"
  - `CONFIG` 는 앱의 설정을 하는 것입니다.
  - `OPTIONS` 에는 앱을 실행 할 때, 어떤 옵션으로 실행 할지 지정하는 것입니다.

```json
{
    "name": "JaeHo - Simulator 12 Pro Max - Macbook 16 - Remote",
    "program": "lib/main.dart",
    "args": [
        "--dart-define",
        "CONFIG=remote",
        "--dart-define",
        "OPTIONS=firebase=off&in_app_purchase=off"
    ],
    "request": "launch",
    "type": "dart",
    "deviceId": "00008030-000904C80290802E"
},
```

# 상태 관리

- Getx 로 합니다.
- `lib/controllers` 폴더에 전역적인 컨트롤러를 저장합니다.
- `lib/controllers/app.controller.dart` 가 앱의 전반적인 상태 관리를 합니다.
- 지역적인 상태 관리가 필요하다면, `lib/screens/**/controllers/*.controller.dart` 와 같이 컨트롤러를 만들면 됩니다.
  - 예를 들어, 회원 관리에만 필요한 컨트롤러가 있다면, `lib/screens/user/controllers/user.controller.dart` 와 같이 컨트롤러 파일을 만들면 됩니다.


# 모델

- `lib/models/**/*.model.dart` 와 같이 모델을 저장합니다.
- 지역적인 모델은 `lib/screens/**/models/*.model.dart` 와 같이 저장합니다.
- 모델 작성 형식은 [표준 문서: Serializing JSON inside model classes](https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes)를 따릅니다.
- JSON 으로 부터 Model 을 작성하기 위해서는 `JSON TO DART` VSCODE 플러그인 를 사용하길 권장합니다.
  다만, 생성된 Model 에 적용된 Null safety 가 원하는 대로 되지 않은 경우, 보정을 해 주어야 합니다.
  - `> JSON TO DART: Convert from Clipboard`
  - `> Support for advance equality check? No`
  - `> Immutable class? No`
  - `> Equality operator? No`
  - `> toString()? Yes`
  - `> Copy with? No`
  - `> Null safety? Yes`
# 백엔드

- pub.dev 에 [x_flutter 패키지](https://pub.dev/packages/x_flutter)가 있습니다. 그 패키지를 사용하여 백엔드와 통신을 합니다.
- Matrix 가 설치되어져 있는 서버 도메인: flutterkorea.com
- 접속 설정은 service/config.dart 에 이미 되어져 있어 그대로 사용하면 됩니다.
- 백엔드 관리자 사용법
  - 게시판 생성 및 게시판 메뉴를 앱에서 보여주는 방법
  - 백엔드 관리자가 푸시를 하는 방법
    - 아이콘 설정
    - 소리 설정



# 파이어베이스

- 파이어베이스는 본 프로젝트에 이미 설정되어져 있으며, 직접 본인의 파이어베이스 프로젝트에 연결하여도 됩니다.

