# X Flutter

이 플러터 패키지는 오픈소스 백엔드인 [Matrix](https://github.com/thruthesky/centerx) 의 기능을 활용할 수 있도록 Restful Api 를 제공합니다.


## 사용법

- 기본 적인 사용법은 소스 코드의 주석으로 설명되어져 있으며 dartdoc 으로 보면 보다 편리하게 주석을 문서로 확인 할 수 있습니다.
- 또한 [Matrix](https://github.com/thruthesky/centerx) 의 API 문서를 보시면 많은 정보를 얻을 수 있습니다.

## 개발자 안내

- 플러터 공식 문서에 나오는데로 패키지 개발 작업을 진행합니다.
- 따라서, 본 패키지를 수정 또는 변경하시려면 공식 문서의 패키지 개발 부분을 읽어 보시면 좋습니다.


## 개발 가이드

- x_flutter 에서 상태 관리를 하지 않습니다.
  - 이 말은, x_flutetr 내에서 회원이 로그인이 되었는지, 또는 가입을 하면 내부적으로 로그인 상태를 기억하기 위해서 local storage 에 세션 ID 를 기록한다던지 하지 않습니다.
  - x_flutter 에서 이러한 작업을 하면 좋겠지만( 그리고 이전 버전에서는 그렇게 했지만 ), 내부적인 상태 관리를 하지 않는 편이 더 간단하게 작성 할 수 있다고 판단해서 입니다.
  - 또한 루트(프로젝트) 앱 내에서 충분히 쉽게 상태 관리를 할 수 있습니다.



## x_flutter 와 GetxController 를 통한 상태 관리 및 코딩 방법

### x_flutter 와 try/catch 및 에러 핸들링

- 일반적인 예외 처리와 동일합니다. 특별히 다른 점은 없습니다.

- 아래의 예제는 try/catch 블럭을 사용하지 않고, 어떻게 에러를 핸들링하는지 보여 주고 있습니다.

```dart
class App extends GetxController {
  register(Map<String, dynamic> data) async {
    // 아래의 Api 호출(회원 가입)에서 에러가 있으면, `.catchError()`가 에러를 받아서, error() 함수를 호출합니다.
    // 만약, 에러가 없으면, error() 함수가 호출되지 않습니다.
    // 에러가 있든 없든 간에 다음 행이 실행된다.
    final user = await Api.instance.user.register(data).catchError(error);
    print('가입 후 회원 정보: $user');
  }

  error(e) {
    print('에러 함수가 실행되었습니다: $e');
  }
}
```

- 아래의 예제는 try/catch 블럭을 사용해서 에러를 핸들링하는 예제를 보여줍니다.

```dart
class App extends GetxController {
  register(Map<String, dynamic> data) async {
    try {
      // 아래의 register() 에서 예외가 발생하면, 다음 라인이 실행되지 않고, catch 블럭으로 넘어갑니다.
      final user = await Api.instance.user.register(data);
      print('가입 후 회원 정보: $user');
    } catch (e) {
      error(e);
    }
  }

  error(e) {
    print('에러 함수가 실행되었습니다: $e');
  }
}
```

- 위 두 예제는 사실 일반적인 dart 의 예외 처리 방식과 동일 한 것입니다.

