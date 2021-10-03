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
  /// if [hasPhoto] is set true, then it will get posts that has featured image. If app uploads an image, the first image becomes featured image.
  /// [withAutoP] is to add <p> tags or not.
  /// [stripTags] is to remove all the HTML tags in title, content.
  ///
  /// ```dart
  /// await PostApi.instance.posts();
  /// ```
  Future<List<WPPost>> posts({
    String? slug,
    int postsPerPage = 10,
    String? searchKeyword,
    int? author,
    String order = 'DESC',
    String orderBy = 'ID',
    int page = 1,
    int id = 0,
    bool hasPhoto = false,
    bool withAutoP = true,
    bool stripTags = false,
  }) async {
    final res = await WordpressApi.instance.request('post.posts', {
      'posts_per_page': postsPerPage,
      if (slug != null) 'category_name': slug,
      if (searchKeyword != null) 's': searchKeyword,
      if (author != null) 'author': author,
      'order': order,
      'orderby': orderBy,
      if (id > 0) 'p': id,
      'meta_query': [
        {
          'key': '_thumbnail_id',
          'compare': 'EXISTS',
        }
      ],
      'with_autop': withAutoP,
      'strip_tags': stripTags,
    });
    final List<WPPost> posts = [];
    for (final p in res) {
      posts.add(WPPost.fromJson(p));
    }
    return posts;
  }
}
