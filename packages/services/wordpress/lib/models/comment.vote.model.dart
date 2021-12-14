import 'package:wordpress/wordpress.dart';

class WPCommentVote {
  int commentId;
  int Y;
  int N;
  WPCommentVote({
    required this.commentId,
    required this.Y,
    required this.N,
  });

  factory WPCommentVote.fromJson(JSON json) {
    return WPCommentVote(
      commentId: toInt(json['comment_ID']),
      Y: toInt(json['Y']),
      N: toInt(json['N']),
    );
  }
}
