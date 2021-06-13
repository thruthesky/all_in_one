/// 앱 설정
///
/// 앱의 모든 설정은 이곳에서 관리가 되어야 한다.
class Config {
  static const appName = String.fromEnvironment('APP_NAME', defaultValue: '앱 이름 없음');
  static const serverUrl =
      String.fromEnvironment('SERVER_URL', defaultValue: 'https://www.flutterkorea.com/index.php');
}
