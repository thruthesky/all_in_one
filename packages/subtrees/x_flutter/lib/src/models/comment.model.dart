import 'package:x_flutter/src/models/forum.model.dart';
import 'package:x_flutter/x_flutter.dart';

class CommentModel extends ForumModel {
  int depth = 0;

  /// 코멘트 작성 모드
  ///
  /// [mode] 가 'edit' 이면 해당 코멘트를 수정한다는 표시.
  /// [mode] 가 'reply' 이면, 해당 코멘트에 새로운 코멘트를 작성하는 표시.
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

  /// 코멘트 작성 또는 수정
  Future<CommentModel> edit(PostModel post) async {
    CommentModel comment = await api.comment.edit(toEdit());

    if (idx == 0) {
      /// 새 코멘트 작성
      if (comment.parentIdx == post.idx) {
        /// 글 바로 아래의 (최 상위, 레벨 1) 댓글. 그냥 맨 마지막에 추가.
        post.comments.add(comment);
      } else {
        /// 코멘트의 코멘트를 작성하는 경우, 중간에 추가하고, depth 를 부모 보다 1 증가.
        int p = post.comments.indexWhere((CommentModel c) => c.idx == comment.parentIdx);
        if (p > -1) {
          post.comments.insert(p + 1, comment);
          comment.depth = post.comments[p].depth + 1;
        }
      }
    } else {
      /// 코멘트 수정
      /// Call by reference 로 기존 객체 업데이트 됨. 아무것도 안해도 됨.
    }

    return comment;
  }
}
