import 'package:x_flutter/src/models/forum.model.dart';
import 'package:x_flutter/x_flutter.dart';

class CommentModel extends ForumModel {
  int depth = 0;
  String mode = '';
  @override
  CommentModel([Map<String, dynamic>? json]) : super(json == null ? {} : json);
  String toString() => 'CommentModel(idx: $idx, content: $content, name: $name)';

  static CommentModel fromJson(Map<String, dynamic> json) {
    final comment = CommentModel(json);
    comment.depth = json['depth'] ?? 0;
    return comment;
  }

  Map<String, dynamic> toJson() {
    final json = super.toJson();
    return json;
  }

  /// 글 작성을 위한 데이터
  Map<String, dynamic> toEdit() {
    return {
      if (idx > 0) 'idx': idx,
      if (rootIdx > 0) 'rootIdx': rootIdx,
      if (parentIdx > 0) 'parentIdx': parentIdx,
      'content': content,
      'files': files.map((file) => file.idx).toSet().join(','),
    };
  }

  /// 글 작성 또는 수정
  Future<CommentModel> edit(PostModel post) async {
    CommentModel comment = await api.comment.edit(toEdit());

    if (comment.parentIdx == post.idx) {
      /// 글 바로 아래의 (최 상위, 레벨 1) 댓글. 그냥 맨 마지막에 추가.
      post.comments.add(comment);
    }

    return comment;
  }
}
