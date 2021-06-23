import 'package:x_flutter/x_flutter.dart';

class CommentApi extends ForumApi {
  /// 백엔드로 부터 코멘트 1개를 가져와서 리턴한다.
  ///
  /// [idx] 는 코멘트 번호
  ///
  /// ```dart
  /// final c = await api.comment.get('path');
  /// print(c);
  /// ```
  Future<CommentModel> get(int idx) async {
    final res = await api.request('comment.get', {'idx': idx});
    return CommentModel.fromJson(res);
  }

  /// 코메늩 검색
  ///
  /// [data] 는 백엔드 컨트롤러 참고
  /// ```dart
  /// final res = await api.comment.search({});
  /// for (final p in res) print(p);
  /// ```
  Future<List<CommentModel>> search(Map<String, dynamic> data) async {
    final res = await api.request('comment.search', data);
    List<CommentModel> comments = [];
    for (final j in res) {
      /// 코멘트를 배열로 가져올 때에는 각 글에 읽기 포인트 등, 글 읽기 제한이 있는 경우, error_not_logged_in 또는 permission 에러가 있을 수 있다.
      if (j is String) throw j;
      comments.add(CommentModel.fromJson(j));
    }
    return comments;
  }

  ///
  Future<CommentModel> edit(Map<String, dynamic> data) async {
    String route;
    if (data['idx'] == null)
      route = 'comment.create';
    else
      route = 'comment.update';

    final json = await api.request(route, data);
    return CommentModel.fromJson(json);
  }

  /// Deletes a comment.
  ///
  Future<CommentModel> delete(int idx) async {
    final res = await api.request('comment.delete', {
      'idx': idx,
    });

    return CommentModel.fromJson(res);
  }
}
