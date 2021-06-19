import 'package:x_flutter/x_flutter.dart';

class PostModel extends ForumModel {
  List<CommentModel> comments = [];
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
}
