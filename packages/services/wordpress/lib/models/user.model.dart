import '../src/wordpress.lib.dart';
import '../defines.dart';

class WPUser {
  int id;
  String email;
  String verifiedEmail;
  String displayName;
  String name;
  String photoUrl;
  String sessionId;
  String firebaseUid;
  String phoneNo;
  int birthdate;
  int age;
  String gender;
  String provider;

  bool get loggedIn => id > 0;
  bool get notLoggedIn => !loggedIn;
  bool get hasPhoneNo => phoneNo != '' && phoneNo.toString().length > 7;
  bool get hasDisplayName => displayName != '';

  WPUser({
    required this.id,
    required this.email,
    required this.verifiedEmail,
    required this.displayName,
    required this.name,
    required this.photoUrl,
    required this.sessionId,
    required this.firebaseUid,
    required this.phoneNo,
    required this.birthdate,
    required this.age,
    required this.gender,
    required this.provider,
  });

  factory WPUser.fromJson(Json json) {
    return WPUser(
      id: toInt(json['ID']),
      email: json['user_email'] ?? '',
      verifiedEmail: json['verifiedEmail'] ?? '',
      displayName: json['display_name'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      sessionId: json['session_id'] ?? '',
      firebaseUid: json['firebase_uid'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      birthdate: toInt(json['birthdate']),
      age: toInt(json['age']),
      gender: json['gender'] ?? '',
      provider: json['provider'] ?? '',
    );
  }

  toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'name': name,
      'photoUrl': photoUrl,
      'sessionId': sessionId,
      'firebaseUid': firebaseUid,
      'phoneNo': phoneNo,
      'birthdate': birthdate,
      'age': age,
      'gender': gender,
      'provider': provider,
    };
  }

  @override
  String toString() {
    return """WPUser(${toJson()})""";
  }
}
