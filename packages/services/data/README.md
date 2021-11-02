# 공공데이터 포털 API

# 참고 문서

[직접 요약한 Tour API 문서](https://docs.google.com/document/d/1ALTwzAyKGDBL7EhdEgCYg8LFfJHlI9vqUsj-4XSf7ns/edit#heading=h.9zg7jz1piaof) 참고

# 개요

대한민국 공공데이터 포털에서 제공하는 각종 Open API 를 플러터에서 손쉽게 사용 할 수 있도록한다.


# Tour API

# 동작방식

- 사용자가 선택 할 수 있는 메뉴를
  - Operation 과 Content Type ID 조합으로 했다.
  - Operation 만으로는 음식점이나 교통 정보를 가져올 수 없다.
  - 또한 Content Type ID 만으로는 내 위치 기반 정보나, 검색어를 사용 할 수 없다.

- 메뉴에서 먼저, 검색 유형을 선택한 다음, 시/도 를 선택 한 후, 구/군/시를 선택 할 수 있는데,
  - 이 때, 검색 유형을 변경하면, 시/군/구 정보가 유지된다. 단, my location, search 는 빼고.



# 테스트 방법

- 응답 데이터를 받아서, 모델링하는데 오류가 있을 있는데, 테스트하는 방법은 tour.api.test.dart 에서 해당(특정) 쿼리를 해서, 응답 코드를 모델링하는 것이다.


# 관광지 정보 검색 방법

- `operation` 은 `TourApiOperations` 중 하나의 값이어야 한다. 기본 값은 `TourApiOperations.areaBasedList` 이다.
- contentTypeId 가 선택되지 않았거나, 0,1,2 이면 전체 콘텐츠 타입을 가져온다.

- 카테고리 대,중,소 만으로 검색하는 방법.

- `search()` 를 호출 할 때, 필수 입력 값은 아무 것도 없다. 그냥 빈 파라메타로 호출해도 된다.

```dart
try {
  final res = await TourApi.instance.search(
    operation: '',
    areaCode: 0,
    sigunguCode: 0,
    contentTypeId: 0,
    pageNo: 1,
    numOfRows: 10,
    keyword: '',
    cat1: 'A02',
    cat2: 'A0207',
    cat3: 'A02070200',
  );
  print('res; ${res.response.body.items.item}');
  for (final TourApiListItem item in res.response.body.items.item) {
    print(item.title);
  }
} catch (e) {
  service.error(e);
}
```

## 검색하는 방법


- `operation` 이 `TourApiOperations.searchKeyword` 이어야 하고, 검색어를 `keyword` 에 지정하면 된다.

- 그 외 추가로 `areaCode`, `sigunguCode`, `cat1,2,3`, `pageNo` 등을 모두 사용 할 수 있다.

- 예)
```dart

```
