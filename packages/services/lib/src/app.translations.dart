import 'package:get/get.dart';

/// 언어화 클래스
///
/// 번역된 텍스트는 서버에 저장되어져 있어, 앱이 실행하면, 번역된 데이터를 다운로드하는 시간이
/// 걸리는데,
/// 이 언어화 클래스는 기본 번역된 텍스트를 포함을 하고 있어서, 앱이 실행하자 마자 기본적인
/// 번역된 텍스트를 사용 할 수 있다.
/// 즉, 첫 화면에 보이는 기본 텍스트는 이 클래스에서 보여주고, 나머지 언어들은 다운로드 하는
/// 대로 보여준다. 이렇게하면, 딜레이 없이 자연스럽게 번역된 언어를 화면에 보여 줄 수 있다.
///
/// 번역된 데이터는 실시간으로 보여지게 할 수 있다.
/// 앱 내에서 10분 또는 1시간 또는 소켓(파이어스토어)연동을 통해서 앱이 새로운 번역 데이터를
/// 다운로드하면, Main(Home) Screen 을 setState() 호출하면 현재 보고 있는 화면에 다시
/// 렌더링 되어, 새로운 텍스트를 보여주는 것이다.
///
/// 참고, 텍스트 키는 공백 없이(또는 공백을 언더바로 대체) 소문자로 통일한다.
/// 모두 소문자로 하기 위해서 [defaultTranslations] 에 담은 후,
/// [updateTranslations] 로 키를 소문자로 변환한다. 같은 변수에 하면
/// Concurrent edit 에러가 발생한다.
Map<String, Map<String, String>> defaultTranslations = {
  "en": {
    "app_name": "Nalia",
  },
  "ko": {
    "app_name": "나리야",
  }
};

Map<String, Map<String, String>> translations = {};

/// 문자열 키는 모두 소문자로 통일
updateTranslations(dynamic data) {
  if (data == null) return;

  /// 번역 텍스트 데이터가 없으면 data 는 List 이다. 번역 데이터가 없으면 그냥 리턴.
  if (data is List) {
    return null;
  }
  if (data.keys.length == 0) return;
  for (String ln in data.keys) {
    for (String code in data[ln].keys) {
      String value = data[ln][code];
      if (translations[ln] == null) translations[ln] = {};
      // 소문자로 변환
      code = code.toLowerCase();
      translations[ln]![code] = value;
    }
  }
}

/// GetX locale 에서 사용할 텍스트 클래스. Translations 를 extends 함
class AppTranslations extends Translations {
  AppTranslations({Map<String, Map<String, String>>? trans}) {
    if (translations.keys.length == 0) updateTranslations(trans ?? defaultTranslations);
  }
  @override
  Map<String, Map<String, String>> get keys => translations;
}
