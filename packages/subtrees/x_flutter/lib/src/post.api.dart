import 'dart:convert';

import 'package:x_flutter/x_flutter.dart';

class PostApi {
  Api get api => Api.instance;

  /// 백엔드로 부터 글 1개를 가져와서 리턴한다.
  ///
  /// [idx] 는 글 번호 또는 글 path 이다.
  ///
  /// ```dart
  /// final c = await api.post.get('path');
  /// print(c);
  /// ```
  Future<PostModel> get(dynamic idx) async {
    assert(idx is int || idx is String, '글 idx 또는 path 를 입력하셔야합니다.');
    final Map<String, dynamic> data = {};
    if (idx is int) {
      data['idx'] = idx;
    } else if (idx is String) {
      data['path'] = idx;
    }
    final res = await Api.instance.request('post.get', data);
    return PostModel.fromJson(res);
  }

  /// 문자열 또는 문자와 숫자를 가지는 배열을 입력 받아 백엔드로 부터 여러 카테고리 정보를 가져옵니다.
  ///
  /// [data] 는 백엔드 컨트롤러 참고
  Future<List<PostModel>> search(Map<String, dynamic> data) async {
    final res = await Api.instance.request('post.search', data);
    List<PostModel> posts = [];
    for (final j in res) {
      print(jsonEncode(j));
      posts.add(PostModel.fromJson(j));
    }
    return posts;
  }
}
