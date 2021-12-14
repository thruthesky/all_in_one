import 'package:wordpress/wordpress.dart';

class WPFile {
  String url;
  String thumbnailUrl;
  String mediumThumbnailUrl;
  String largeThumbnailUrl;
  int id;
  String name;
  String type;

  WPFile({
    required this.url,
    required this.thumbnailUrl,
    required this.mediumThumbnailUrl,
    required this.largeThumbnailUrl,
    required this.id,
    required this.name,
    required this.type,
  });

  factory WPFile.fromJson(MapStringDynamic data) {
    return WPFile(
      url: data['url'] ?? '',
      thumbnailUrl: data['thumbnail_url'] ?? '',
      mediumThumbnailUrl: data['medium_thumbnail_url'] ?? '',
      largeThumbnailUrl: data['large_thumbnail_url'] ?? '',
      id: data['ID'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? '',
    );
  }

  toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'mediumThumbnailUrl': mediumThumbnailUrl,
      'largeThumbnailUrl': largeThumbnailUrl,
    };
  }

  @override
  String toString() {
    return "WPFile( ${toMap()} )";
  }

  /// 파일 삭제
  ///
  ///
  Future<WPFile> delete([dynamic postOrComment]) async {
    final file = await FileApi.instance.delete(id);
    if (postOrComment != null) {
      int i = postOrComment.files.indexWhere((WPFile f) => f.id == id);
      if (i > -1) {
        postOrComment.files.removeAt(i);
      }
    }
    return file;
  }
}
