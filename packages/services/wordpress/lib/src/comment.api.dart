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
}
