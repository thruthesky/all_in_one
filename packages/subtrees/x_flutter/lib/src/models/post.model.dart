import 'package:x_flutter/x_flutter.dart';

/// 글 모델
///
/// 글과 코멘트는 하나의 테이블을 사용하므로, 모델도 유사하다.
///
/// 빈 글을 생성하기 위해서는 아래와 같이 하면 된다.
/// ```dart
/// PostModel({});
/// PostModel(); // 이 코드와 위 코드는 동일하다.
///
/// posts.add(PostModel({})..setNoMorePosts());
/// posts.add(PostModel()..setNoMorePosts());
/// ```
class PostModel extends ForumModel {
  List<CommentModel> comments = [];

  /// 더 이상 목록할 글이 없으면 또는 현재 카테고리에서 모든 글을 가져왔으면,
  /// 맨 마지막 글에 [noMorePosts] 가 true 가 지정된다.
  /// 참고로 맨 마지막 글은 가짜 글(빈 글)이다.
  bool noMorePosts = false;

  /// 글 제목을 눌러서 글 내용을 보고자 할 때, 이 값이 참이된다.
  bool open = false;
  bool get close => !open;

  @override
  PostModel([Map<String, dynamic>? json]) : super(json ?? {}) {
    if (json == null) json = {};
    if (json['comments'] != null && json['comments'].length > 0) {
      for (final c in json['comments']) {
        comments.add(CommentModel.fromJson(c));
      }
    }

    if (idx > 0) {
      if (deleted) {
        /// 글이 삭제된 경우,
        title = '삭제되었습니다.';
        content = '삭제되었습니다.';
      } else if (title == '') {
        /// 제목이 없는 경우,
        title = '제목이 없습니다.';
      }
    }
  }
  String toString() => 'PostModel(${toJson()})';

  static PostModel fromJson(Map<String, dynamic> json) => PostModel(json);

  /// 글 작성용 데이터 출력이 아니다.
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['comments'] = comments;
    return json;
  }

  /// 글 작성을 위한 데이터
  Map<String, dynamic> toEdit() {
    return {
      if (idx > 0) 'idx': idx,
      if (relationIdx > 0) 'relationIdx': relationIdx,
      if (categoryId != '') 'categoryId': categoryId,
      'title': title,
      'content': content,
      'subcategory': subcategory,
      'files': files.map((file) => file.idx).toSet().join(','),
      'code': code,
    };
  }

  setNoMorePosts() {
    noMorePosts = true;
  }

  /// 글 작성 또는 수정
  Future<PostModel> edit() {
    return api.post.edit(toEdit());
  }

  /// 글 삭제
  ///
  /// 글 삭제 후, 현재 객체에 반영
  Future<PostModel> delete() async {
    PostModel p = await api.post.delete(idx);
    title = p.title;
    content = p.content;
    deletedAt = p.deletedAt;
    return this;
  }
}
