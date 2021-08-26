import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();
  // static FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  /// 'app_open' 이라는 표준 이벤트를 파이어베이스 애널리스틱로 전송한다.
  /// Use this method on app start up.
  /// If you are using Getx controller for the app, then Getx::onInit() is a good place to call this method.
  static Future<void> logAppOpen() {
    return _analytics.logAppOpen();
  }

  /// 파이어베이스 애널리스틱스에 이벤트를 전송한다.
  static Future<void> logEvent(String name, [Map<String, Object?>? parameters]) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  /// 파이어베이스 애널리스틱스에 현재 화면 이름을 보내, 사용자가 어떤 화면에 더 많이 접근했는지 표시한다.
  static Future<void> setCurrentScreen(String screenName) {
    return _analytics.setCurrentScreen(screenName: screenName);
  }

  /// 표준 로그인 이벤트
  /// 사용자가 로그인을 할 때 호출하면 된다.
  static Future<void> logLogin({String? loginMethod}) {
    return _analytics.logLogin(loginMethod: loginMethod);
  }

  /// 회원 가입
  ///
  /// 회원 가입을 할 때 호출하면 된다.
  static Future<void> logSignUp({
    required String signUpMethod,
  }) {
    return _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  /// 표준 검색 이벤트
  /// 사용자가 검색 할 때, 이 이벤트를 호출
  static Future<void> logSearch({required String searchTerm}) {
    return _analytics.logSearch(searchTerm: searchTerm);
  }

  /// 사용자가 특정 컨텐츠를 선택(읽기) 했을 때 호출
  ///
  /// 컨텐츠에 제한은 없다. 예를 들어, 글 읽와 같은 경우에 해도 되지만, 글 읽기나 사진 보기와 같이 매우 간단한 것은 `logViewItem()` 을 사용한다.
  ///
  /// When user tapped on a button(or list) to read/open post view page.
  static Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) {
    return _analytics.logSelectContent(contentType: contentType, itemId: itemId);
  }

  /// Similar to logSelectContent
  static Future<void> logViewItem({
    required String itemId,
    required String itemName,
    required String itemCategory,
  }) {
    return _analytics.logViewItem(itemId: itemId, itemName: itemName, itemCategory: itemCategory);
  }

  /// 사용자가 앱 공유를 했을 때, 호출
  /// 어떤 데이터를 공유하는지 알 수 있음.
  ///
  /// When user shared a content.
  static Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) {
    return _analytics.logShare(contentType: contentType, itemId: itemId, method: method);
  }
}
