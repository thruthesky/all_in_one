import '../../../data.functions.dart';
import '../../../data.defines.dart';

/// 리스트 결과를 그대로 modeling 한 것으로,
/// 검색, detail common, detail intro 등에서 같이 사용한다.
class TourApiListModel {
  TourApiListModel({required this.response});
  final TourApiListResponse response;
  factory TourApiListModel.fromJson(Json json) => TourApiListModel(
        response: TourApiListResponse.fromJson(json['response']),
      );

  addMoreImages(Json json) {
    final List<TourImage> images = [];
    // print('addMoreImages: $json');
    if (json['response'] != null &&
        json['response']['body'] != null &&
        json['response']['body']['items'] != null) {
      final items = json['response']['body']['items'];
      // print('items; $items');
      if (items['item'] is Map) {
        images.add(
          TourImage(
              smallimageurl: items['item']['smallimageurl'],
              originimgurl: items['item']['originimgurl']),
        );
      } else if (items['item'] is List) {
        for (final img in items['item']) {
          images.add(
            TourImage(smallimageurl: img['smallimageurl'], originimgurl: img['originimgurl']),
          );
        }
      }
      response.body.items.item.first.images = images;
    }
    // print('images; $images');
  }
}

class TourImage {
  String smallimageurl;
  String originimgurl;
  TourImage({required this.smallimageurl, required this.originimgurl});
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
    /// ! 이 것을 첫번째 배열로 바꾸어 준다.
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
    required this.addr1,
    required this.addr2,
    required this.areacode,
    required this.cat1,
    required this.cat2,
    required this.cat3,
    required this.contentid,
    required this.contenttypeid,
    required this.createdtime,
    required this.firstimage,
    required this.firstimage2,
    required this.mapx,
    required this.mapy,
    required this.masterid,
    required this.mlevel,
    required this.modifiedtime,
    required this.readcount,
    required this.sigungucode,
    required this.tel,
    required this.title,
    required this.zipcode,
    required this.homepage,
    required this.telname,
    required this.overview,
    required this.directions,
  });

  final String addr1;
  final String addr2;
  final int areacode;
  final String cat1;
  final String cat2;
  final String cat3;
  final int contentid;
  final int contenttypeid;
  final int createdtime;
  final String firstimage;
  final String firstimage2;
  final double mapx;
  final double mapy;
  final int masterid;
  final int mlevel;
  final int modifiedtime;
  final int readcount;
  final int sigungucode;
  final String tel;
  final String title;
  final String zipcode;
  final String homepage;
  final String telname;
  final String overview;
  final String directions;

  List<TourImage> images = [];

  String get englishTitle => _removeKorean(title);
  String get englishAddr2 => _removeKorean(addr2);

  /// 문자열 끝에 한글이 같이 출력된다.
  /// 예)
  ///   14 abc [14가나다]
  ///   14 abc (14 가나다)
  /// 로직)
  /// 위에서 14 abc 부분만 출력 하도록 한다.
  /// 먼저 맨 끝의 괄호 부분을 없애고,
  /// 그리고, 한글을 모두 제거하고,
  /// 맨 끝에 특수문자, 숫자가 없을 때 까지 제거한다.
  ///
  /// @note 완벽하지는 않지만, 안정적으로(큰 문제를 일으키지 않고), 한글을 제거한다.
  String _removeKorean(String s) {
    /// replaceAll(RegExp('NAME'), 'Bob');
    String _title = s;

    if (_title.endsWith(')')) {
      int i = _title.lastIndexOf('(');
      if (i > -1) {
        _title = _title.substring(0, i);
      }
    }

    _title = _title.replaceAll(RegExp('[가-힣]+'), '');
    _title = _title.replaceAll(RegExp(r'\s[\[\]\/\(\) 0-9]+$'), '');
    return _title;
  }

  String get overviewText {
    String _overview = overview;
    _overview = _overview.replaceAll('<br>', "\n");
    return _overview;
  }

  String get directionsText {
    String _directions = directions;
    _directions = _directions.replaceAll('<br>', "\n");
    return _directions;
  }

  String get homepageUrl {
    if (homepage == '') return '';
    final match = RegExp(r'http([^\"]*)').firstMatch(homepage);
    if (match == null) return '';
    return match.group(0) ?? '';
  }

  factory TourApiListItem.fromJson(Json json) => TourApiListItem(
        addr1: toString(json["addr1"]),
        addr2: toString(json["addr2"]),
        areacode: toInt(json["areacode"]),
        cat1: toString(json["cat1"]),
        cat2: toString(json["cat2"]),
        cat3: toString(json["cat3"]),
        contentid: toInt(json["contentid"]),
        contenttypeid: toInt(json["contenttypeid"]),
        createdtime: toInt(json["createdtime"]),
        firstimage: toString(json["firstimage"]),
        firstimage2: toString(json["firstimage2"]),
        mapx: toDouble(json['mapx']),
        mapy: toDouble(json['mapy']),
        masterid: toInt(json["masterid"]),
        mlevel: toInt(json["mlevel"]),
        modifiedtime: toInt(json["modifiedtime"]),
        readcount: toInt(json["readcount"]),
        sigungucode: toInt(json["sigungucode"]),
        tel: toString(json["tel"]),
        title: toString(json["title"]),
        zipcode: toString(json['zipcode']),

        /// detailCommon
        homepage: tourApiHomepage(json['homepage']),
        telname: toString(json['telname']),
        overview: toString(json['overview']),
        directions: toString(json['directions']),
      );
}
