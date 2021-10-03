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

  final String commentId;
  final String commentPostId;
  final String commentParent;
  final String userId;
  final String commentAuthor;
  final String commentContent;
  final DateTime commentDate;
  final List<dynamic> files;
  final String commentAuthorPhotoUrl;
  final String shortDateTime;
  final int depth;

  factory WPComment.fromJson(Map<String, dynamic> json) => WPComment(
        commentId: json["comment_ID"],
        commentPostId: json["comment_post_ID"],
        commentParent: json["comment_parent"],
        userId: json["user_id"],
        commentAuthor: json["comment_author"],
        commentContent: json["comment_content"],
        commentDate: DateTime.parse(json["comment_date"]),
        files: List<dynamic>.from(json["files"].map((x) => x)),
        commentAuthorPhotoUrl: json["comment_author_profile_photo_url"],
        shortDateTime: json["short_date_time"],
        depth: json["depth"],
      );

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
}
