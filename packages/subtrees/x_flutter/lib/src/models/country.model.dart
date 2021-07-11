class CountryModel {
  int idx;
  String koreanName;
  String englishName;
  String officialName;
  String alpha2;
  String alpha3;
  String currencyCode;
  String currencyKoreanName;
  String currencySymbol;
  int numericCode;
  String latitude;
  String longitude;
  int createdAt;
  int updatedAt;

  CountryModel({
    this.idx = 0,
    this.koreanName = '',
    this.englishName = '',
    this.officialName = '',
    this.alpha2 = '',
    this.alpha3 = '',
    this.currencyCode = '',
    this.currencyKoreanName = '',
    this.currencySymbol = '',
    this.numericCode = 0,
    this.latitude = '',
    this.longitude = '',
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  @override
  String toString() {
    return 'CountryModel(idx: $idx, koreanName: $koreanName, englishName: $englishName, officialName: $officialName, alpha2: $alpha2, alpha3: $alpha3, currencyCode: $currencyCode, currencyKoreanName: $currencyKoreanName, currencySymbol: $currencySymbol, numericCode: $numericCode, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        idx: json['idx'],
        koreanName: json['koreanName'],
        englishName: json['englishName'],
        officialName: json['officialName'],
        alpha2: json['alpha2'],
        alpha3: json['alpha3'],
        currencyCode: json['currencyCode'],
        currencyKoreanName: json['currencyKoreanName'],
        currencySymbol: json['currencySymbol'],
        numericCode: json['numericCode'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'idx': idx,
        'koreanName': koreanName,
        'englishName': englishName,
        'officialName': officialName,
        'alpha2': alpha2,
        'alpha3': alpha3,
        'currencyCode': currencyCode,
        'currencyKoreanName': currencyKoreanName,
        'currencySymbol': currencySymbol,
        'numericCode': numericCode,
        'latitude': latitude,
        'longitude': longitude,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
