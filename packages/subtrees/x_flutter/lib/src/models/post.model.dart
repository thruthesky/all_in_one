import 'package:x_flutter/src/models/forum.model.dart';

class PostModel extends ForumModel {
  late String subject;

  @override
  PostModel(Map<String, dynamic> json) : super(json);
  String toString() => 'PostModel(idx: $idx, subject: $subject, name: $name)';

  static PostModel fromJson(Map<String, dynamic> json) {
    final post = PostModel(json);
    post.subject = json['subject'] ?? '';
    return post;
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'name': name,
    };
  }
}
