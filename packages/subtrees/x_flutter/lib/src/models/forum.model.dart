import 'package:x_flutter/x_flutter.dart';

class ForumModel {
  Api api = Api.instance;
  int idx;
  int rootIdx;
  int parentIdx;
  int categoryIdx;
  int relationIdx;
  int userIdx;
  int otherUserIdx;
  String subcategory;
  String title;
  String path;
  String content;
  String private;
  String privateTitle;
  String privateContent;
  int noOfComments;
  int noOfViews;
  String reminder;
  int listOrder;
  List<FileModel> files = [];
  int Y;
  int N;
  int report;
  String code;
  String name;
  String companyName;
  String phoneNo;
  String countryCode;
  String province;
  String city;
  String address;
  String zipcode;
  // ignore: non_constant_identifier_names
  int Ymd;
  int createdAt;
  int readAt;
  int updatedAt;
  int deletedAt;
  int beginAt;
  int endAt;
  String beginDate;
  String endDate;
  String url;
  String relativeUrl;
  int appliedPoint;
  String shortDate;
  String categoryId;
  UserModel user = UserModel();

  ForumModel(Map<String, dynamic> json)
      : idx = json['idx'] ?? 0,
        rootIdx = json['rootIdx'] ?? 0,
        parentIdx = json['parentIdx'] ?? 0,
        categoryIdx = json['categoryIdx'] ?? 0,
        relationIdx = json['relationIdx'] ?? 0,
        userIdx = json['userIdx'] ?? 0,
        otherUserIdx = json['otherUserIdx'] ?? 0,
        subcategory = json['subcategory'] ?? '',
        title = json['title'] ?? '',
        path = json['path'] ?? '',
        content = json['content'] ?? '',
        private = json['private'] ?? '',
        privateTitle = json['privateTitle'] ?? '',
        privateContent = json['privateContent'] ?? '',
        noOfComments = json['noOfComments'] ?? 0,
        noOfViews = json['noOfViews'] ?? 0,
        reminder = json['reminder'] ?? '',
        listOrder = json['listOrder'] ?? 0,
        Y = json['Y'] ?? 0,
        N = json['N'] ?? 0,
        report = json['report'] ?? 0,
        code = json['code'] ?? '',
        name = json['name'] ?? '',
        companyName = json['companyName'] ?? '',
        phoneNo = json['phoneNo'] ?? '',
        countryCode = json['countryCode'] ?? '',
        province = json['province'] ?? '',
        city = json['city'] ?? '',
        address = json['address'] ?? '',
        zipcode = json['zipcode'] ?? '',
        // ignore: non_constant_identifier_names
        Ymd = json['Ymd'] ?? 0,
        createdAt = json['createdAt'] ?? 0,
        readAt = json['readAt'] ?? 0,
        updatedAt = json['updatedAt'] ?? 0,
        deletedAt = json['deletedAt'] ?? 0,
        beginAt = json['beginAt'] ?? 0,
        endAt = json['endAt'] ?? 0,
        beginDate = json['beginDate'] ?? '',
        endDate = json['endDate'] ?? '',
        url = json['url'] ?? '',
        relativeUrl = json['relativeUrl'] ?? '',
        appliedPoint = json['appliedPoint'] ?? 0,
        shortDate = json['shortDate'] ?? '',
        categoryId = json['categoryId'] ?? '' {
    if (json['files'] != null && json['files'].length > 0) {
      for (final f in json['files']) {
        files.add(FileModel.fromJson(f));
      }
    }

    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
  }

  bool get deleted => deletedAt > 0;
  bool get isPost => parentIdx == 0;
  bool get isComment => !isPost;

  @override
  String toString() => 'ForumModel(name: $name)';

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'categoryId': categoryId,
      'categoryIdx': categoryIdx,
      'parentIdx': parentIdx,
      'title': title,
      'content': content,
      'user': user.toJson()
    };
  }

  /// 추천을 하고, 현재 객체에 반영.
  Future<Map<String, int>> like() async {
    final Map<String, int> re = await api.post.like(idx);
    this.Y = re['Y'] ?? 0;
    this.N = re['N'] ?? 0;

    return re;
  }

  /// 비추천을 하고, 현재 객체에 반영.
  Future<Map<String, int>> dislike() async {
    final Map<String, int> re = await api.post.dislike(idx);
    this.Y = re['Y'] ?? 0;
    this.N = re['N'] ?? 0;

    return re;
  }
}
