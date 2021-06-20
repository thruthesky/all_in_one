import 'package:x_flutter/src/models/forum.model.dart';

class CommentModel extends ForumModel {
  int depth = 0;
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
  Future<CommentModel> edit() {
    return api.comment.edit(toEdit());
  }
}
