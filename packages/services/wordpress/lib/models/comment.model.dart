import 'package:wordpress/models/file.model.dart';
import 'package:wordpress/src/wordpress.lib.dart';
import 'package:wordpress/wordpress.dart';

class WPComment {
  WPComment({
    required this.commentId,
    required this.commentPostId,
    required this.commentParent,
    required this.userId,
    required this.commentAuthor,
    required this.commentContent,
    required this.commentDate,
    required this.files,
    required this.commentAuthorPhotoUrl,
    required this.shortDateTime,
    required this.depth,
  });

  int commentId;
  int commentPostId;
  int commentParent;
  final int userId;
  final String commentAuthor;
  String commentContent;
  final DateTime commentDate;
  final List<WPFile> files;
  final String commentAuthorPhotoUrl;
  final String shortDateTime;
  int depth;

  ///
  String mode = '';

  /// TODO - wordpress 에서도 글 삭제하면, deleted 로 표시되어져야 하나??
  bool deleted = false;

  factory WPComment.fromJson(Map<String, dynamic> json) => WPComment(
        commentId: toInt(json["comment_ID"]),
        commentPostId: toInt(json["comment_post_ID"]),
        commentParent: toInt(json["comment_parent"]),
        userId: toInt(json["user_id"]),
        commentAuthor: json["comment_author"] ?? '',
        commentContent: json["comment_content"] ?? '',
        commentDate:
            json["comment_date"] != null ? DateTime.parse(json["comment_date"]) : DateTime.now(),
        files: List<WPFile>.from((json["files"] ?? []).map((x) => x)),
        commentAuthorPhotoUrl: json["comment_author_profile_photo_url"] ?? '',
        shortDateTime: json["short_date_time"] ?? '',
        depth: toInt(json["depth"]),
      );

  factory WPComment.empty() {
    return WPComment.fromJson({});
  }

  Map<String, dynamic> toJson() => {
        "comment_ID": commentId,
        "comment_post_ID": commentPostId,
        "comment_parent": commentParent,
        "user_id": userId,
        "comment_author": commentAuthor,
        "comment_content": commentContent,
        "comment_date": commentDate.toIso8601String(),
        "files": List<dynamic>.from(files.map((x) => x)),
        "commentAuthorPhotoUrl": commentAuthorPhotoUrl,
        "short_date_time": shortDateTime,
        "depth": depth,
      };

  /// 글 작성을 위한 데이터
  Map<String, dynamic> toEdit() {
    return {
      if (commentId > 0) 'comment_ID': commentId,
      if (commentParent > 0) 'comment_parent': commentParent,
      'content': commentContent,
      'fileIdxes': files.map((WPFile file) => file.id).toSet().join(','),
    };
  }

  /// 코멘트 작성 또는 수정
  Future<WPComment> edit(WPPost post) async {
    WPComment comment = await CommentApi.instance.edit(toEdit());

    if (commentId == 0) {
      /// 새 코멘트 작성
      if (comment.commentParent == post.id) {
        /// 글 바로 아래의 (최 상위, 레벨 1) 댓글. 그냥 맨 마지막에 추가.
        post.comments.add(comment);
      } else {
        /// 코멘트의 코멘트를 작성하는 경우, 중간에 추가하고, depth 를 부모 보다 1 증가.
        int p = post.comments.indexWhere((WPComment c) => c.commentId == comment.commentParent);
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

  Future vote({bool like = false}) async {
    if (like) {
      // TODO - comment.like;
      // await comment.like();
    } else {
      // TODO - comment.dislike
      // await comment.dislike();
    }
  }

  Future report() async {
    // TODO - comment.report();
    // await commnet.report();
  }

  Future delete() async {
    // TODO - comment.delete();
    // await commnet.delete();
  }
}
