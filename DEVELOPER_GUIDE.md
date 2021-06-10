# 만능앱 개발자 가이드

본 문서는 만능앱 개발을 위한 개발자 문서이며, 개발 멤버들이 보다 쉽게 프로젝트 참여를 하고 성공적인 결과를 만들어내기 위해서 따라야 할 가이드라인을 제사합니다.

# 스터디 공부해야 할 순서

- 온라인 세미나 참여
- 깃 이슈 및 프로젝트 참고
- 앱 설치 및 실행
- 편집기 설정
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
  

# 이슈 및 개발 작업 공간

- [Git Projects 참고](https://github.com/thruthesky/all_in_one/projects/1)

# 설치

## 만능앱 프로젝트 설치

- 플러터 최신 버전을 설치하고
- 본 프로젝트를 clone 하면 됩니다.

## Flutter 코드 개발 편집기

- 통일성 있게 `VSCode` 를 사용합니다.
- VSCode Better comment 플러그인을 활용합니다.
  사용하는 태그는 아래와 같습니다.
  - `@attention` (json 설정에서 강조 표시 필요)
  - `@todo`

## 문서화

- `$ dartdoc`
  - 만약, 문서화에 에러가 있으면, 플러터 폴더에 들어 있는 `dartdoc` 명령을 실행한다.
  - 예) `$HOME/bin/flutter/bin/cache/dart-sdk/bin/dartdoc --exclude 'dart:async,dart:collection,dart:convert,dart:core,dart:developer,dart:ffi,dart:html,dart:io,dart:isolate,dart:js,dart:js_util,dart:math,dart:typed_data,dart:ui'`
- `$ npm i -g http-server`
- `$ http-server doc/api`

## 백엔드 설치

- 백엔드는 CenterX 를 사용합니다. CenterX 는 도커 기반에 Nginx + PHP + MariaDB 로 작성된 오픈 소스입니다.
- 백엔드 설치는 CenterX 문서를 사용하면 되며,
- 직접 개발 컴퓨터에 설치해서 테스트를 해도 되고,
- 본 프로젝트를 위해서 미리 준비한 실제 서버를 사용해도 됩니다.
- 본 문서의 백엔드를 참고해 주세요.


# 테스트

- 테스트는 공식 문서의 Integration Test 를 진행합니다.



# 백엔드

- CenterX 가 설치되어져 있는 서버 도메인: flutterkorea.com
- 접속 설정은 service/config.dart 에 이미 되어져 있어 그대로 사용하면 됩니다.

# 파이어베이스

- 파이어베이스는 본 프로젝트에 이미 설정되어져 있으며, 직접 본인의 파이어베이스 프로젝트에 연결하여도 됩니다.

