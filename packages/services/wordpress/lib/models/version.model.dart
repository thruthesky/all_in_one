import 'package:wordpress/wordpress.dart';

class WPVersion {
  String version;
  String date;
  int userId;
  WPVersion({
    required this.version,
    required this.date,
    required this.userId,
  });

  factory WPVersion.fromJson(JSON json) {
    return WPVersion(
      userId: toInt(json['user_ID']),
      version: toStr(json['version']),
      date: toStr(json['date']),
    );
  }
}
