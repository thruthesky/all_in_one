import 'package:x_flutter/x_flutter.dart';

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
  PostModel(Map<String, dynamic> json) : super(json) {
    if (json['comments'] != null && json['comments'].length > 0) {
      for (final c in json['comments']) {
        comments.add(CommentModel.fromJson(c));
      }
    }
  }
  String toString() => 'PostModel(idx: $idx, title: $title, name: $name)';

  static PostModel fromJson(Map<String, dynamic> json) => PostModel(json);

  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['comments'] = comments;
    return json;
  }

  setNoMorePosts() {
    noMorePosts = true;
  }
}
