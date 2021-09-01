import 'package:get/get.dart';
import 'package:data/data.dart';
import 'package:data/src/tour/models/tour.api.area_code.model.dart';

class TourListController extends GetxController {
  static TourListController get to => Get.find<TourListController>();

  late TourApiListModel listModel;

  bool loading = false;
  bool noMoreData = false;
  int numOfRows = 20;
  int pageNo = 1;

  /// 테스트 하는 방법. README.md 참고
  /// areaCode 가 36 이면 경상남도, sigunguCode 가 4 이면, 김해시
  /// 선택없음 0. 1 이면 geoIp 기본. 2 이면 검색. 그외는 contentTypeId. 기본 값: 76 관광지.
  /// 여기에 기본 값을 지정하면, dropdown button 에 기본 값을 선택해서 보여준다. 단, 값을 실제 가져오기 위해서는 [contentTypeId] 에 값을 줘야 한다.
  int operationType = 0;

  /// 사용자가 [operationType] 을 선택하면, 적절한 operation 값을 저장.
  String operation = '';

  /// 사용자가 [operationType] 을 선택하면, 적절한 contentTypeId 지정.
  /// 여기에 기본 값을 지정하면, 화면이 나타나자 마자 검색해서 결과를 가져 올 수 있다.
  int contentTypeId = 76;

  int areaCode = 0; // 기본 값 0
  int sigunguCode = 0; // 기본 값 0
  // 도시 검색에서 구/동 목록
  List<TourApiAreaCodeModel> cities = [];
  List<TourCard> items = [];

  reset({
    int? operationType,
    int? areaCode,
    int? sigunguCode,
  }) {
    loading = false;
    noMoreData = false;
    pageNo = 1;
    items = [];
    if (operationType != null) this.operationType = operationType;
    if (areaCode != null) this.areaCode = areaCode;
    if (sigunguCode != null) this.sigunguCode = sigunguCode;
    update();
    loadPage();
    loadArea();
  }

  /// 서비스 유형(operation): 관광지, 숙소, 행사 등 변경
  /// 컨텐츠 Type id: 숙소, 교통, 음식점 등
  ///
  /// 서비스 유형과 컨텐츠 타입을 동시 지원.
  ///
  /// City, Festival, Accommodation 에서는 areaCode 와 sigunguCode 를 초기화 하지 않는다.
  /// @see data/README.md 동작방식 참고
  changeOperationType(int operationType) {
    if (this.operationType == operationType) {
      return false;
    }

    operation = TourApiOperations.areaBasedList;
    if (operationType == 1)
      operation = TourApiOperations.locationBasedList;
    else if (operationType == 2) operation = TourApiOperations.searchKeyword;

    contentTypeId = operationType > 2 ? operationType : 0;

    /// GeoIP 기반 목록이면, 초기화
    if (operation == TourApiOperations.locationBasedList) {
      reset(operationType: operationType, areaCode: 0, sigunguCode: 0);
    } else {
      reset(operationType: operationType, areaCode: areaCode, sigunguCode: sigunguCode);
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
    );

    pageNo++;
    setLoading(false);
    if (listModel.response.body.items.item.length < numOfRows) noMoreData = true;
    listModel.response.body.items.item.forEach((e) {
      items.add(TourCard(item: e, index: 0));
    });
    print('items.length; ${items.length}, totalCount; ${listModel.response.body.totalCount}');
  }
}
