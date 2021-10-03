import '../src/wordpress.lib.dart';
import '../defines.dart';

class WPUser {
  int id;
  String email;
  String verifiedEmail;
  String displayName;
  String name;
  String photoUrl;
  int photoId;
  String socialLoginPhotoUrl;
  String sessionId;
  String firebaseUid;
  String phoneNo;
  int birthdate;
  int age;
  String gender;
  String provider;

  String firstName;
  String lastName;
  String domain;
  String registered;

  bool get loggedIn => id > 0;
  bool get notLoggedIn => !loggedIn;
  bool get hasPhoneNo => phoneNo != '' && phoneNo.toString().length > 7;
  bool get hasDisplayName => displayName != '';
  bool get hasPhoto => photoUrl != '';

  WPUser({
    required this.id,
    required this.email,
    required this.verifiedEmail,
    required this.displayName,
    required this.name,
    required this.photoUrl,
    required this.photoId,
    required this.socialLoginPhotoUrl,
    required this.sessionId,
    required this.firebaseUid,
    required this.phoneNo,
    required this.birthdate,
    required this.age,
    required this.gender,
    required this.provider,
    required this.firstName,
    required this.lastName,
    required this.domain,
    required this.registered,
  });

  factory WPUser.fromJson(MapStringDynamic json) {
    return WPUser(
      id: toInt(json['ID']),
      email: json['user_email'] ?? '',
      verifiedEmail: json['verifiedEmail'] ?? '',
      displayName: json['display_name'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['profile_photo_url'] ?? '',
      photoId: toInt(json['profile_photo_id']),
      socialLoginPhotoUrl: json['socialLoginPhotoUrl'] ?? '',
      sessionId: json['session_id'] ?? '',
      firebaseUid: json['firebaseUid'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      birthdate: toInt(json['birthdate']),
      age: toInt(json['age']),
      gender: json['gender'] ?? '',
      provider: json['provider'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      domain: json['domain'] ?? '',
      registered: json['user_registered'] ?? '',
    );
  }

  toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'name': name,
      'photoUrl': photoUrl,
      'photoId': photoId,
      'socialLoginPhotoUrl': socialLoginPhotoUrl,
      'sessionId': sessionId,
      'firebaseUid': firebaseUid,
      'phoneNo': phoneNo,
      'birthdate': birthdate,
      'age': age,
      'gender': gender,
      'provider': provider,
      'firstName': firstName,
      'lastName': lastName,
      'domain': domain,
      'registered': registered,
    };
  }

  @override
  String toString() {
    return """WPUser(${toJson()})""";
  }
}
