import 'package:wordpress/models/comment.vote.model.dart';
import 'package:wordpress/wordpress.dart';

class CommentApi {
  /// Singleton
  static CommentApi? _instance;
  static CommentApi get instance {
    if (_instance == null) {
      _instance = CommentApi();
    }
    return _instance!;
  }

  /// This will make an Http request for editting post.
  ///
  /// Editting can either be creating or updating.
  Future<WPComment> edit(MapStringDynamic data) async {
    final res = await WordpressApi.instance.request('comment.edit', data);
    return WPComment.fromJson(res);
  }

  /// This will make an Http request for deleting coment.
  ///
  Future<int> delete(int commentId) async {
    final res = await WordpressApi.instance.request('comment.delete', {'comment_ID': commentId});
    return toInt(res['comment_ID']);
  }

  /// Note, it uses `post.vote` for post, and `comment.vote` for comment.
  Future<WPCommentVote> vote({
    // ignore: non_constant_identifier_names
    required int ID,
    // ignore: non_constant_identifier_names
    required String Yn,
  }) async {
    final res = await WordpressApi.instance.request('comment.vote', {'target_ID': ID, 'Yn': Yn});
    return WPCommentVote.fromJson(res);
  }
}
