import 'package:wordpress/models/post.vote.model.dart';
import 'package:wordpress/wordpress.dart';

class PostApi {
  /// Singleton
  static PostApi? _instance;
  static PostApi get instance {
    if (_instance == null) {
      _instance = PostApi();
    }
    return _instance!;
  }

  /// Get posts from wordpress using `get_posts` method.
  ///
  /// See `WP_Query` for details at: https://developer.wordpress.org/reference/classes/wp_query/parse_query/
  ///
  /// [id] to get only one post.
  /// [page] is the page number.
  /// [postsPerPage] is the number of the posts to show in a page.
  /// if [hasPhoto] is set true, then it will get posts that has featured image.
  ///   - Note that, it only gets posts that has featured image. Not just any post that has images.
  ///   - If app uploads an image, the first image becomes featured image.
  /// [withAutoP] is to add <p> tags or not.
  /// [stripTags] is to remove all the HTML tags in title, content.
  /// [minimize] is to retreive minimal post data.
  ///
  /// ```dart
  /// await PostApi.instance.posts();
  /// ```
  Future<List<WPPost>> posts({
    String? slug,
    int page = 1,
    int postsPerPage = 10,
    String? searchKeyword,
    int? author,
    String order = 'DESC',
    String orderBy = 'ID',
    int id = 0,
    bool hasPhoto = false,
    bool withAutoP = false,
    bool stripTags = false,
    bool minimize = false,
    bool log = false,
    PostsCacheCallback? cacheCallback,
  }) async {
    final res = await WordpressApi.instance.request(
      'post.posts',
      data: {
        'paged': page,
        'posts_per_page': postsPerPage,
        if (slug != null) 'category_name': slug,
        if (searchKeyword != null) 's': searchKeyword,
        if (author != null && author > 0) 'author': author,
        'order': order,
        'orderby': orderBy,
        if (id > 0) 'p': id,
        if (hasPhoto)
          'meta_query': [
            {
              'key': '_thumbnail_id',
              'compare': 'EXISTS',
            }
          ],
        'with_autop': withAutoP,
        'strip_tags': stripTags,
        'minimize': minimize,
        if (log) 'debug_log': true,
      },
      cacheCallback: cacheCallback == null
          ? null
          : (res) {
              final List<WPPost> posts = [];
              for (final p in res) {
                posts.add(WPPost.fromJson(p));
              }
              cacheCallback(posts);
            },
    );
    final List<WPPost> posts = [];
    for (final p in res) {
      posts.add(WPPost.fromJson(p));
    }
    return posts;
  }

  Future<WPPost> get(int id) async {
    final res = await WordpressApi.instance.request('post.get', data: {'ID': id});
    return WPPost.fromJson(res);
  }

  Future<WPPost> getByCode(String code) async {
    final res = await WordpressApi.instance.request('post.getByCode', data: {'code': code});
    return WPPost.fromJson(res);
  }

  @Deprecated("'code' is not used any more.")
  Future<List<WPPost>> getByCodes(List<String> codes) async {
    final res = await WordpressApi.instance.request('post.getByCodes', data: {'codes': codes});
    final List<WPPost> posts = [];
    for (final p in res) {
      posts.add(WPPost.fromJson(p));
    }
    return posts;
  }

  /// This will make an Http request for editting post.
  ///
  /// Editting can either be creating or updating.
  Future<WPPost> edit(MapStringDynamic data) async {
    final res = await WordpressApi.instance.request('post.edit', data: data);
    return WPPost.fromJson(res);
  }

  /// This will make an Http request for deleting post.
  ///
  Future<int> delete(int id) async {
    final res = await WordpressApi.instance.request('post.delete', data: {'ID': id});
    return toInt(res['ID']);
  }

  Future<int> report(int id) async {
    final res = await WordpressApi.instance.request('post.report', data: {'ID': id});
    return toInt(res['ID']);
  }

  /// Note, it uses `post.vote` for post, and `comment.vote` for comment.
  Future<WPPostVote> vote({
    // ignore: non_constant_identifier_names
    required int ID,
    // ignore: non_constant_identifier_names
    required String Yn,
  }) async {
    final res = await WordpressApi.instance.request('post.vote', data: {'target_ID': ID, 'Yn': Yn});
    print('vote; res; $res');
    return WPPostVote.fromJson(res);
  }

  Future<int> setFeaturedImage({required int id, required int imageId}) async {
    final res = await WordpressApi.instance
        .request('post.setFeaturedImage', data: {'ID': id, 'image_ID': imageId});
    print('vote; res; $res');
    return res['ID'];
  }
}
