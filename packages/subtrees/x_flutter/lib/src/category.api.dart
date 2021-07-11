import 'package:x_flutter/src/models/category.model.dart';
import 'package:x_flutter/x_flutter.dart';

class CategoryApi {
  Api get api => Api.instance;

  /// 백엔드로 부터 카테고리 1개를 가져와서 리턴한다.
  ///
  /// ```dart
  /// final c = await api.category.get('qna');
  /// print(c);
  /// ```
  Future<CategoryModel> get(dynamic idx) async {
    assert(idx is int || idx is String, '카테고리 idx 또는 id 를 입력하셔야합니다.');
    final Map<String, dynamic> data = {};
    if (idx is int) {
      data['idx'] = idx;
    } else if (idx is String) {
      data['categoryId'] = idx;
    }
    final res = await Api.instance.request('category.get', data);
    return CategoryModel.fromJson(res);
  }

  /// 문자열 또는 문자와 숫자를 가지는 배열을 입력 받아 백엔드로 부터 여러 카테고리 정보를 가져옵니다.
  ///
  /// [input] 은 `a,2,c` 또는 `['a', 2, 'c']` 와 같이 입력 할 수 있습니다.
  /// ```dart
  /// final cs = await api.category.gets('qna,2');
  /// print(cs);
  /// ```
  Future<List<CategoryModel>> gets(dynamic input) async {
    assert(input is String || input is List, '문자열 또는 배열을 입력하셔야 합니다.');
    final res = await Api.instance.request('category.gets', {'ids': input});
    List<CategoryModel> cats = [];
    for (final j in res) {
      cats.add(CategoryModel.fromJson(j));
    }
    return cats;
  }
}
