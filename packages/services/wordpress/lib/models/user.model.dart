import '../src/wordpress.lib.dart';

class WPUser {
  int id;
  String email;
  String displayName;
  String name;
  String photoUrl;
  String sessionId;
  String firebaseUID;
  String mobile;
  String birthday;

  bool get hasMobile => mobile != '' && mobile.toString().length > 7;

  bool get hasDisplayName => displayName != '';

  WPUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.name,
    required this.photoUrl,
    required this.sessionId,
    required this.firebaseUID,
    required this.mobile,
    required this.birthday,
  });

  factory WPUser.fromJson(Json json) {
    return WPUser(
      id: toInt(json['ID']),
      email: json['user_email'] ?? '',
      displayName: json['displayName'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      sessionId: json['session_id'],
      firebaseUID: json['firebase_uid'] ?? '',
      mobile: json['mobile'] ?? '',
      birthday: json['birthday'] ?? '',
    );
  }

  @override
  String toString() {
    return """$id, $email, $displayName""";
  }
}
