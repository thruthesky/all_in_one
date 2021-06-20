import 'package:x_flutter/src/models/forum.model.dart';

class CommentModel extends ForumModel {
  @override
  CommentModel([Map<String, dynamic>? json]) : super(json == null ? {} : json);
  String toString() => 'CommentModel(idx: $idx, content: $content, name: $name)';

  static CommentModel fromJson(Map<String, dynamic> json) {
    final post = CommentModel(json);
    return post;
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'name': name,
    };
  }
}
