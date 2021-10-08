import 'package:wordpress/models/comment.vote.model.dart';
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
    required this.Y,
    required this.N,
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

  int Y;
  int N;

  ///
  String mode = '';

  /// TODO - wordpress 에서도 글 삭제하면, deleted 로 표시되어져야 하나?? 그렇다. issue 가 만들어져 있다. 이것은 나중에 처리를 한다.
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
        files: List<WPFile>.from((json["files"] ?? []).map((x) => WPFile.fromJson(x))),
        commentAuthorPhotoUrl: json["comment_author_profile_photo_url"] ?? '',
        shortDateTime: json["short_date_time"] ?? '',
        depth: toInt(json["depth"]),
        Y: toInt(json["Y"]),
        N: toInt(json["N"]),
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
  JSON toEdit() {
    return {
      if (commentId > 0) 'comment_ID': commentId,
      if (commentParent > 0) 'comment_parent': commentParent,
      'comment_content': commentContent,
      'fileIds': files.map((WPFile file) => file.id).toSet().join(','),
    };
  }

  /// 코멘트 작성 또는 수정
  /// Comment edit(create or update)
  ///
  Future<WPComment> edit(WPPost post) async {
    JSON json = toEdit();
    json[COMMENT_POST_ID] = post.id;

    WPComment comment = await CommentApi.instance.edit(json);

    if (commentId == 0) {
      /// 새 코멘트 작성
      /// Create new comment
      if (comment.commentParent == 0 || comment.commentParent == post.id) {
        /// 글 바로 아래의 (최 상위, 레벨 1) 댓글. 그냥 맨 마지막에 추가.
        post.comments.add(comment);
      } else {
        /// Update comment
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

  // ignore: non_constant_identifier_names
  // Future vote(String Yn) {
  //   return CommentApi.instance.vote(ID: commentId, Yn: Yn);
  // }

  // ignore: non_constant_identifier_names
  Future<WPCommentVote> vote(String Yn) async {
    final vote = await CommentApi.instance.vote(ID: commentId, Yn: Yn);
    this.Y = vote.Y;
    this.N = vote.N;
    return vote;
  }

  Future report() async {
    // TODO - comment.report();
    // await commnet.report();
  }

  Future<int> delete() async {
    return await CommentApi.instance.delete(commentId);
  }
}
