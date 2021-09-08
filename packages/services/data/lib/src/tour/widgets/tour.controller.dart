import 'package:get/get.dart';
import 'package:data/data.dart';
import 'package:data/src/tour/models/tour.api.area_code.model.dart';

/// 상태 관리
/// 모든 상태과 로직을 이 컨트롤러에서 관리한다.
/// 로직도 같이 관리하므로, 페이지 이동 등도 여기서 담당한다.
/// 루트 앱과 완전히 분리하기 위해서, 다음 스크린 이동 등의 정보를 받는다.
class TourController extends GetxController {
  TourController({required this.routeView});
  static TourController get to => Get.find<TourController>();

  final String routeView;

  late TourApiListModel listModel;

  bool loading = false;
  bool noMoreData = false;
  int numOfRows = 20;
  int pageNo = 1;

  /// 테스트 하는 방법. README.md 참고
  ///
  /// [contentTypeId] 가 메뉴 항목에서, 맨 왼쪽(처음 선택하는) 메뉴이다. 이것은 operation 과 contentTypeId 가 같이 표시되는 것이다.
  /// README 참고

  /// 사용자가 [operationType] 을 선택하면, 적절한 contentTypeId 지정.
  /// 여기에 기본 값을 지정하면, 화면이 나타나자 마자 검색해서 결과를 가져 올 수 있다.
  /// 만약, contentTypeId 가 선택되지 않았으면, 전체 콘텐츠 타입 정보를 가져온다.
  int contentTypeId = 0;
  int previousContentTypeId = 0;

  int areaCode = 0; // 기본 값 0
  int sigunguCode = 0; // 기본 값 0
  // 도시 검색에서 구/동 목록
  List<TourApiAreaCodeModel> cities = [];

  /// 검색 결과를 담는 항목
  List<TourApiListItem> items = [];

  /// 검색 박스를 보여 줄지 표시.
  bool displaySearchBox = false;

  /// 검색어
  String keyword = '';

  /// 검색 박스에 단어가 입력이 되었으면 true 가 된다.
  bool dirty = false;

  reset({
    int? contentTypeId,
    int? areaCode,
    required int sigunguCode,
    String? keyword,
  }) {
    loading = false;
    noMoreData = false;
    pageNo = 1;
    items = [];
    if (contentTypeId != null) this.contentTypeId = contentTypeId;
    if (areaCode != null) this.areaCode = areaCode;
    this.sigunguCode = sigunguCode;
    if (keyword != null) this.keyword = keyword;
    update();
    loadPage();
    loadArea();
  }

  String get operation {
    if (contentTypeId == 1)
      return TourApiOperations.locationBasedList;
    else if (contentTypeId == 2)
      return TourApiOperations.searchKeyword;
    else
      return TourApiOperations.areaBasedList;
  }

  /// 서비스 유형(operation): 관광지, 숙소, 행사 등 변경
  /// 컨텐츠 Type id: 숙소, 교통, 음식점 등
  ///
  /// 서비스 유형과 컨텐츠 타입을 동시 지원.
  ///
  /// City, Festival, Accommodation 에서는 areaCode 와 sigunguCode 를 초기화 하지 않는다.
  /// @see data/README.md 동작방식 참고
  changeContentTypeId(int contentTypeId) {
    if (this.contentTypeId == contentTypeId) {
      return false;
    }

    /// GeoLocation 기반 목록이면, 목록 초기화. GeoLocation 기반 결과를 보여 줘야 함.
    if (contentTypeId == ContentTypeId.myLocation) {
      reset(contentTypeId: contentTypeId, areaCode: 0, sigunguCode: 0);
    } else if (contentTypeId == ContentTypeId.searchKeyword) {
      /// 키워드 검색을 선택했으면, 현재 화면(목록 내용)을 그대로 유지한채, 검색 박스만 보여준다.
      dirty = false;
      displaySearchBox = true;
      if (previousContentTypeId != contentTypeId) {
        previousContentTypeId = this.contentTypeId;
      }
      this.contentTypeId = contentTypeId;
      update();
    } else {
      /// 그 외, 관광지, 쇼핑몰, 음식점 등이면,
      reset(contentTypeId: contentTypeId, areaCode: areaCode, sigunguCode: sigunguCode);
    }
  }

  setLoading(bool f) {
    loading = f;
    update();
  }

  loadArea() async {
    if (areaCode == 0) return;
    cities = await TourApi.instance.areaCode(areaCode: areaCode);
    update();
  }

  loadPage() async {
    print('loading; $loading, noMoreData; $noMoreData');
    if (loading || noMoreData) {
      print('loading on page; $pageNo');
      return;
    }
    setLoading(true);
    print('loading pageNo: $pageNo');

    /// geoIp 기반 목록 또는 searchKeyword 이 아니면, 모두 areaBasedList

    listModel = await TourApi.instance.search(
      operation: operation,
      areaCode: areaCode,
      sigunguCode: sigunguCode,

      /// operationType 이 2 보다 크면, 실제 contentTypeId 이다.
      contentTypeId: contentTypeId,
      pageNo: pageNo,
      numOfRows: numOfRows,
      keyword: keyword,
    );

    pageNo++;
    setLoading(false);
    if (listModel.response.body.items.item.length < numOfRows) noMoreData = true;
    listModel.response.body.items.item.forEach((e) {
      items.add(e);
    });
    print('items.length; ${items.length}, totalCount; ${listModel.response.body.totalCount}');
  }

  onKeywordChange(String keyword) {
    dirty = true;
    reset(
      contentTypeId: ContentTypeId.searchKeyword,
      areaCode: 0,
      sigunguCode: 0,
      keyword: keyword,
    );
  }

  onCancelSearch() {
    displaySearchBox = false;

    if (dirty) {
      reset(contentTypeId: 0, areaCode: 0, sigunguCode: 0, keyword: '');
    } else {
      contentTypeId = previousContentTypeId;
      update();
    }
  }

  view(int index) {
    print('index; $index');
    Get.toNamed(routeView, arguments: {'index': index});
  }
}
