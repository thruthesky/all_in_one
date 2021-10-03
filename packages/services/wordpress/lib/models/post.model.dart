import 'package:wordpress/models/comment.model.dart';
import 'package:wordpress/models/file.model.dart';
import 'package:wordpress/src/wordpress.lib.dart';

class WPPost {
  WPPost({
    required this.pingme,
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
    required this.shortDateTime,
    required this.comments,
    required this.category,
    required this.featuredImageUrl,
    required this.featuredImageId,
    required this.featuredImageThumbnailUrl,
    required this.featuredImageMediumThumbnailUrl,
    required this.featuredImageLargeThumbnailUrl,
  });

  final String pingme;
  final int id;
  final String postAuthor;
  final DateTime postDate;
  final String content;
  final String title;
  final DateTime postModified;
  final int postParent;
  final String guid;
  final String commentCount;
  final List<int> postCategory;
  final String url;
  final List<WPFile> files;
  final String authorName;
  final String shortDateTime;
  final List<WPComment> comments;
  final String category;
  final String featuredImageUrl;

  final int featuredImageId;
  final String featuredImageThumbnailUrl;
  final String featuredImageMediumThumbnailUrl;
  final String featuredImageLargeThumbnailUrl;

  factory WPPost.fromJson(Map<String, dynamic> json) => WPPost(
        pingme: json["_pingme"],
        id: json["ID"],
        postAuthor: json["post_author"],
        postDate: DateTime.parse(json["post_date"]),
        content: json["post_content"],
        title: json["post_title"],
        postModified: DateTime.parse(json["post_modified"]),
        postParent: json["post_parent"],
        guid: json["guid"],
        commentCount: json["comment_count"],
        postCategory: List<int>.from(json["post_category"].map((x) => x)),
        url: json["url"],
        files: List<WPFile>.from(json["files"].map((x) => WPFile.fromJson(x))),
        authorName: json["author_name"],
        shortDateTime: json["short_date_time"],
        comments: List<WPComment>.from(json["comments"].map((x) => WPComment.fromJson(x))),
        category: json["category"],
        featuredImageUrl: json['featured_image_url'] ?? '',
        featuredImageId: toInt(json['featured_image_ID']),
        featuredImageThumbnailUrl: json['featured_image_default_thumbnail_url'] ?? '',
        featuredImageMediumThumbnailUrl: json['featured_image_medium_thumbnail_url'] ?? '',
        featuredImageLargeThumbnailUrl: json['featured_image_large_thumbnail_url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_pingme": pingme,
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
        "category": category,
        "featuredImageUrl": featuredImageUrl,
        'featuredImageId': featuredImageId,
        'featuredImageThumbnailUrl': featuredImageThumbnailUrl,
        'featuredImageMediumThumbnailUrl': 'featuredImageMediumThumbnailUrl',
        'featuredImageLargeThumbnailUrl': featuredImageLargeThumbnailUrl,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
