import 'package:wordpress/models/comment.model.dart';
import 'package:wordpress/models/file.model.dart';
import 'package:wordpress/models/post.vote.model.dart';
import 'package:wordpress/src/wordpress.lib.dart';
import 'package:wordpress/wordpress.dart';

class WPPost {
  WPPost({
    required this.id,
    required this.postAuthor,
    required this.postDate,
    required this.content,
    required this.title,
    required this.postModified,
    required this.postParent,
    required this.guid,
    required this.commentCount,
    required this.postCategory,
    required this.url,
    required this.files,
    required this.authorName,
    required this.authorProfilePhotoUrl,
    required this.shortDateTime,
    required this.comments,
    required this.slug,
    required this.featuredImageUrl,
    required this.featuredImageId,
    required this.featuredImageThumbnailUrl,
    required this.featuredImageMediumThumbnailUrl,
    required this.featuredImageLargeThumbnailUrl,
    required this.Y,
    required this.N,
  });

  final int id;
  final int postAuthor;
  final DateTime postDate;
  String content;
  String title;
  final DateTime postModified;
  final int postParent;
  final String guid;
  final String commentCount;
  final List<int> postCategory;
  final String url;
  List<WPFile> files;
  final String authorName;
  final String authorProfilePhotoUrl;
  final String shortDateTime;
  final List<WPComment> comments;
  String slug;
  final String featuredImageUrl;

  final int featuredImageId;
  final String featuredImageThumbnailUrl;
  final String featuredImageMediumThumbnailUrl;
  final String featuredImageLargeThumbnailUrl;

  int Y;
  int N;

  /// Client options.
  bool get hasPhoto => featuredImageId > 0 && featuredImageUrl != '';
  bool open = false;
  bool noMorePosts = false;

  /// TODO - wordpress 에서도 글 삭제하면, deleted 로 표시되어져야 하나??
  bool deleted = false;
  bool close = false;
  setNoMorePosts() {
    noMorePosts = true;
  }

  factory WPPost.fromJson(Map<String, dynamic> json) => WPPost(
        id: toInt(json["ID"]),
        postAuthor: toInt(json["post_author"]),
        postDate: json["post_date"] == null ? DateTime.now() : DateTime.parse(json["post_date"]),
        content: json["post_content"] ?? '',
        title: json["post_title"] ?? '',
        postModified:
            json["post_modified"] == null ? DateTime.now() : DateTime.parse(json["post_modified"]),
        postParent: toInt(json["post_parent"]),
        guid: json["guid"] ?? '',
        commentCount: json["comment_count"] ?? '',
        postCategory: List<int>.from((json["post_category"] ?? []).map((x) => x)),
        url: json["url"] ?? '',
        files: List<WPFile>.from((json["files"] ?? []).map((x) => WPFile.fromJson(x))),
        authorName: json["author_name"] ?? '',
        authorProfilePhotoUrl: json["author_profile_photo_url"] ?? '',
        shortDateTime: json["short_date_time"] ?? '',
        comments: List<WPComment>.from((json["comments"] ?? []).map((x) => WPComment.fromJson(x))),
        slug: json["slug"] ?? '',
        featuredImageUrl: json['featured_image_url'] ?? '',
        featuredImageId: toInt(json['featured_image_ID']),
        featuredImageThumbnailUrl: json['featured_image_default_thumbnail_url'] ?? '',
        featuredImageMediumThumbnailUrl: json['featured_image_medium_thumbnail_url'] ?? '',
        featuredImageLargeThumbnailUrl: json['featured_image_large_thumbnail_url'] ?? '',
        Y: toInt(json['Y']),
        N: toInt(json['N']),
      );

  factory WPPost.empty() {
    return WPPost.fromJson({});
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "post_author": postAuthor,
        "post_date": postDate.toIso8601String(),
        "post_content": content,
        "post_title": title,
        "post_modified": postModified.toIso8601String(),
        "post_parent": postParent,
        "guid": guid,
        "comment_count": commentCount,
        "post_category": List<dynamic>.from(postCategory.map((x) => x)),
        "url": url,
        "files": List<dynamic>.from(files.map((x) => x)),
        "author_name": authorName,
        "short_date_time": shortDateTime,
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "slug": slug,
        "featuredImageUrl": featuredImageUrl,
        'featuredImageId': featuredImageId,
        'featuredImageThumbnailUrl': featuredImageThumbnailUrl,
        'featuredImageMediumThumbnailUrl': 'featuredImageMediumThumbnailUrl',
        'featuredImageLargeThumbnailUrl': featuredImageLargeThumbnailUrl,
        'Y': Y,
        'N': N,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  factory WPPost.copy(WPPost post) {
    return WPPost.fromJson(post.toJson());
  }

  /// 글 작성을 위한 데이터
  Map<String, dynamic> toEdit() {
    return {
      if (id > 0) 'ID': id,
      if (slug != '') 'slug': slug,
      'post_title': title,
      'post_content': content,
      'fileIds': files.map((file) => file.id).toSet().join(','),
    };
  }

  /// 글 작성 또는 수정
  Future<WPPost> edit() {
    return PostApi.instance.edit(toEdit());
  }

  // ignore: non_constant_identifier_names
  Future<WPPostVote> vote(String Yn) async {
    final vote = await PostApi.instance.vote(ID: id, Yn: Yn);
    print('vote; $vote');
    this.Y = vote.Y;
    this.N = vote.N;
    return vote;
  }

  Future report() async {
    // TODO - post.report();
    // await post.report();
  }

  Future<int> delete() async {
    return await PostApi.instance.delete(id);
  }
}
