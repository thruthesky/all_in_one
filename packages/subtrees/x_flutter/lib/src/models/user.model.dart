/// 사용자 모델
///
/// 빈 값을 가지는 사용자 모델 객체를 생성하기 위해서는 UserModel() 또는 UserModel.init() 을
/// 사용하면 된다.

class UserModel {
  int idx;
  String email;
  String orgEmail;
  String firebaseUid;
  String name;
  String nickname;
  int photoIdx;
  String photoUrl;
  int point;
  int level;
  int levelPercentage;
  String block;
  String phoneNo;
  String gender;
  int birthdate;
  String domain;
  String countryCode;
  String province;
  String city;
  String address;
  String zipcode;
  String provider;
  String verifier;
  int createdAt;
  int updatedAt;
  String sessionId;
  String admin;
  String displayName;
  int age;
  String verified;

  Map<String, dynamic> data;

  UserModel({
    this.idx = 0,
    this.email = '',
    this.orgEmail = '',
    this.firebaseUid = '',
    this.name = '',
    this.nickname = '',
    this.photoIdx = 0,
    this.photoUrl = '',
    this.point = 0,
    this.level = 0,
    this.levelPercentage = 0,
    this.block = '',
    this.phoneNo = '',
    this.gender = '',
    this.birthdate = 0,
    this.domain = '',
    this.countryCode = '',
    this.province = '',
    this.city = '',
    this.address = '',
    this.zipcode = '',
    this.provider = '',
    this.verifier = '',
    this.createdAt = 0,
    this.updatedAt = 0,
    this.sessionId = '',
    this.admin = '',
    this.displayName = '',
    this.age = 0,
    this.verified = '',
    this.data = const {},
  });

  bool get loggedIn => idx > 0;
  bool get hasPhoto => photoIdx > 0;

  String get signIn {
    if (provider.contains('google'))
      return 'google';
    else if (provider.contains('apple'))
      return 'apple';
    else if (provider.contains('facebook'))
      return 'facebook';
    else if (provider.contains('anonymous'))
      return 'anonymous';
    else
      return '';
  }

  bool isSubscribeTopic(topic) {
    if (!this.loggedIn) return false;
    return this.data[topic] != null && this.data[topic] == 'Y';
  }

  /// JSON 을 문자열로 변환한 것으로, JSON encode 용도로 사용하지 않도록 주의 한다.
  /// 즉, encode 가 필요한 경우는 jsonEncode(user.toJson()) 와 같이 한다.
  @override
  String toString() {
    return toJson().toString();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        idx: json['idx'] as int,
        email: json['email'] ?? '',
        orgEmail: json['orgEmail'] ?? '',
        firebaseUid: json['firebaseUid'] ?? '',
        name: json['name'] ?? '',
        nickname: json['nickname'] ?? '',
        photoIdx: json['photoIdx'] ?? 0,
        photoUrl: json['photoUrl'] ?? '',
        point: json['point'] ?? 0,
        level: json['level'] ?? 0,
        levelPercentage: json['level'] ?? 0,
        block: json['block'] ?? '',
        phoneNo: json['phoneNo'] ?? '',
        gender: json['gender'] ?? '',
        birthdate: json['birthdate'] ?? 0,
        domain: json['domain'] ?? '',
        countryCode: json['countryCode'] ?? '',
        province: json['province'] ?? '',
        city: json['city'] ?? '',
        address: json['address'] ?? '',
        zipcode: json['zipcode'] ?? '',
        provider: json['provider'] ?? '',
        verifier: json['verifier'] ?? '',
        createdAt: json['createdAt'] ?? 0,
        updatedAt: json['updatedAt'] ?? 0,
        sessionId: json['sessionId'] ?? '',
        admin: json['admin'] ?? '',
        displayName: json['displayName'] ?? '',
        age: json['age'] ?? 0,
        verified: json['verified'] ?? '',
        data: json);
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'email': email,
      'orgEmail': orgEmail,
      'firebaseUid': firebaseUid,
      'name': name,
      'nickname': nickname,
      'photoIdx': photoIdx,
      'photoUrl': photoUrl,
      'point': point,
      'level': level,
      'levelPercentage': levelPercentage,
      'block': block,
      'phoneNo': phoneNo,
      'gender': gender,
      'birthdate': birthdate,
      'domain': domain,
      'countryCode': countryCode,
      'province': province,
      'city': city,
      'address': address,
      'zipcode': zipcode,
      'provider': provider,
      'verifier': verifier,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'sessionId': sessionId,
      'admin': admin,
      'displayName': displayName,
      'age': age,
      'verified': verified,
    };
  }
}
