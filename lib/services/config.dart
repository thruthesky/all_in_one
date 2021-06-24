/// 앱 설정
///
/// 앱의 모든 설정은 이곳에서 관리가 되어야 한다.
class Config {
  static const appName =
      String.fromEnvironment('APP_NAME', defaultValue: '앱 이름 없음');
  static const serverUrl = String.fromEnvironment('SERVER_URL',
      defaultValue: 'https://www.flutterkorea.com/index.php');

  /// iOS 앱을 다운로드 또는 다른 친구에게 공유해서 알려줄 때 사용
  static const iOSAppDownloadUrl = 'https://www.philgo.com';

  /// Android 앱을 다운로드 또는 다른 친구에게 공유해서 알려줄 때 사용
  static const androidAppDownloadUrl = 'https://www.philgo.com';

  /// 사용할 게시판 카테고리. README 참고.
  static const List<String> categories = ['qna', 'discussion', 'reminder'];

  /// 날씨 정보. API Key 와 업데이트 주기
  static String openWeatherMapApiKey = '7cb555e44cdaac586538369ac275a33b';
  static const int openWeatherMapUpdateInterval = 180;
}
