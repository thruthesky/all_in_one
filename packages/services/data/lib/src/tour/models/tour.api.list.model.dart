import '../../../data.functions.dart';
import '../../../data.defines.dart';

/// 리스트 결과를 그대로 modeling 한 것이다.
class TourApiListModel {
  TourApiListModel({required this.response});
  final TourApiListResponse response;
  factory TourApiListModel.fromJson(Json json) => TourApiListModel(
        response: TourApiListResponse.fromJson(json['response']),
      );
}

class TourApiListResponse {
  TourApiListResponse({
    required this.header,
    required this.body,
  });

  final TourApiListHeader header;
  final TourApiListBody body;

  factory TourApiListResponse.fromJson(Json json) => TourApiListResponse(
        header: TourApiListHeader.fromJson(json['header']),
        body: TourApiListBody.fromJson(json['body']),
      );
}

class TourApiListHeader {
  TourApiListHeader({
    required this.resultCode,
    required this.resultMsg,
  });

  final String resultCode;
  final String resultMsg;

  factory TourApiListHeader.fromJson(Json json) => TourApiListHeader(
        resultCode: json["resultCode"],
        resultMsg: json["resultMsg"],
      );
}

class TourApiListBody {
  TourApiListBody({
    required this.items,
    required this.numOfRows,
    required this.pageNo,
    required this.totalCount,
  });

  final Items items;
  final int numOfRows;
  final int pageNo;
  final int totalCount;

  factory TourApiListBody.fromJson(Json json) {
    Json items = {};
    if (json['items'] is String) {
    } else {
      items = json['items'];
    }
    return TourApiListBody(
      items: Items.fromJson(items),
      numOfRows: json["numOfRows"] == null ? 0 : json["numOfRows"],
      pageNo: json["pageNo"] == null ? 0 : json["pageNo"],
      totalCount: json["totalCount"] == null ? 0 : json["totalCount"],
    );
  }
}

class Items {
  Items({
    required this.item,
  });

  final List<TourApiListItem> item;

  factory Items.fromJson(Json json) {
    if (json['item'] == null) return Items(item: []);

    /// ! 검색 결과가 1개 뿐인 경우, json['item'] 이 배열이 아니라, 맵에 바로 데이터가 전달되어 온다.
    if (json['item'] is Map) {
      return Items(item: [TourApiListItem.fromJson(json['item'])]);
    }
    return Items(
      item: List<TourApiListItem>.from(json["item"].map((x) => TourApiListItem.fromJson(x))),
    );
  }
}

class TourApiListItem {
  TourApiListItem({
    this.addr1,
    this.addr2,
    this.areacode,
    this.cat1,
    this.cat2,
    this.cat3,
    this.contentid,
    this.contenttypeid,
    this.createdtime,
    this.firstimage,
    this.firstimage2,
    this.mapx,
    this.mapy,
    this.masterid,
    this.mlevel,
    this.modifiedtime,
    this.readcount,
    this.sigungucode,
    this.tel,
    required this.title,
    this.zipcode,
  });

  final String? addr1;
  final String? addr2;
  final int? areacode;
  final String? cat1;
  final String? cat2;
  final String? cat3;
  final int? contentid;
  final int? contenttypeid;
  final int? createdtime;
  final String? firstimage;
  final String? firstimage2;
  final double? mapx;
  final double? mapy;
  final int? masterid;
  final int? mlevel;
  final int? modifiedtime;
  final int? readcount;
  final int? sigungucode;
  final String? tel;
  final String title;
  final String? zipcode;

  String get englishTitle {
    /// replaceAll(RegExp('NAME'), 'Bob');
    return title.replaceAll(RegExp('/가-힣/'), '');
    // if (title.endsWith(')')) {
    //   int i = title.lastIndexOf('(');
    //   if (i > -1) {
    //     return title.substring(0, i);
    //   } else {
    //     return title;
    //   }
    // } else {
    //   return title;
    // }
  }

  factory TourApiListItem.fromJson(Json json) => TourApiListItem(
        addr1: json["addr1"] == null ? null : toString(json["addr1"]),
        addr2: json["addr2"] == null ? null : toString(json["addr2"]),
        areacode: json["areacode"] == null ? null : json["areacode"],
        cat1: json["cat1"] == null ? null : json["cat1"],
        cat2: json["cat2"] == null ? null : json["cat2"],
        cat3: json["cat3"] == null ? null : json["cat3"],
        contentid: json["contentid"] == null ? null : json["contentid"],
        contenttypeid: json["contenttypeid"] == null ? null : json["contenttypeid"],
        createdtime: json["createdtime"] == null ? null : json["createdtime"],
        firstimage: json["firstimage"] == null ? null : json["firstimage"],
        firstimage2: json["firstimage2"] == null ? null : json["firstimage2"],
        mapx: json["mapx"] == null ? 0 : toDouble(json['mapx']),
        mapy: json["mapy"] == null ? 0 : toDouble(json['mapy']),
        masterid: json["masterid"] == null ? null : json["masterid"],
        mlevel: json["mlevel"] == null ? null : json["mlevel"],
        modifiedtime: json["modifiedtime"] == null ? null : json["modifiedtime"],
        readcount: json["readcount"] == null ? null : json["readcount"],
        sigungucode: json["sigungucode"] == null ? null : json["sigungucode"],
        tel: json["tel"] == null ? null : json["tel"],
        title: json["title"] == null ? '' : json["title"],
        zipcode: toString(json['zipcode']),
      );
}
