import 'package:wordpress/models/comment.vote.model.dart';
import 'package:wordpress/wordpress.dart';

class WPComment {
  WPComment({
    required this.commentId,
    required this.commentPostId,
    required this.commentParent,
    required this.userId,
    required this.commentAuthor,
    required this.commentAuthorFirebaseUid,
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
  final String commentAuthorFirebaseUid;
  String commentContent;
  final DateTime commentDate;
  final List<WPFile> files;
  final String commentAuthorPhotoUrl;
  final String shortDateTime;
  int depth;

  int Y;
  int N;

  /// If it is 'reply', then it will show a reply box.
  /// If it is 'eidt', then it will show an edit box.
  String mode = '';
  bool get inEditMode => mode == 'edit';
  bool get inViewMode => mode == '';
  bool get inReplyMode => mode == 'reply';

  bool deleted = false;

  factory WPComment.fromJson(Map<String, dynamic> json) => WPComment(
        commentId: toInt(json["comment_ID"]),
        commentPostId: toInt(json["comment_post_ID"]),
        commentParent: toInt(json["comment_parent"]),
        userId: toInt(json["user_id"]),
        commentAuthor: json["comment_author"] ?? '',
        commentAuthorFirebaseUid: json["comment_author_firebase_uid"] ?? '',
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
        "commentAuthorFirebaseUid": commentAuthorFirebaseUid,
        "comment_content": commentContent,
        "comment_date": commentDate.toIso8601String(),
        "files": List<dynamic>.from(files.map((x) => x)),
        "commentAuthorPhotoUrl": commentAuthorPhotoUrl,
        "short_date_time": shortDateTime,
        "depth": depth,
      };

  /// ??? ????????? ?????? ?????????
  JSON toEdit() {
    return {
      if (commentId > 0) 'comment_ID': commentId,
      if (commentParent > 0) 'comment_parent': commentParent,
      'comment_content': commentContent,
      'fileIds': files.map((WPFile file) => file.id).toSet().join(','),
    };
  }

  /// ????????? ?????? ?????? ??????
  /// Comment edit(create or update)
  ///
  Future<WPComment> edit(WPPost post) async {
    JSON json = toEdit();
    json[COMMENT_POST_ID] = post.id;

    WPComment comment = await CommentApi.instance.edit(json);

    if (commentId == 0) {
      /// ??? ????????? ??????
      /// Create new comment
      if (comment.commentParent == 0 || comment.commentParent == post.id) {
        /// ??? ?????? ????????? (??? ??????, ?????? 1) ??????. ?????? ??? ???????????? ??????.
        post.comments.add(comment);
      } else {
        /// Update comment
        /// ???????????? ???????????? ???????????? ??????, ????????? ????????????, depth ??? ?????? ?????? 1 ??????.
        int p = post.comments.indexWhere((WPComment c) => c.commentId == comment.commentParent);
        if (p > -1) {
          post.comments.insert(p + 1, comment);
          comment.depth = post.comments[p].depth + 1;
        }
      }
    } else {
      /// ????????? ??????
      /// Call by reference ??? ?????? ?????? ???????????? ???. ???????????? ????????? ???.
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
    await CommentApi.instance.report(commentId);
  }

  Future<int> delete() async {
    return await CommentApi.instance.delete(commentId);
  }
}
