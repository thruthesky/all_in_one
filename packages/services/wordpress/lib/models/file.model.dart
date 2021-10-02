import '../defines.dart';

class WPFile {
  String url;
  String thumbnailUrl;
  int id;
  String name;
  String type;

  WPFile({
    required this.url,
    required this.thumbnailUrl,
    required this.id,
    required this.name,
    required this.type,
  });

  factory WPFile.fromJson(Json data) {
    return WPFile(
      url: data['url'],
      thumbnailUrl: data['thumbnail_url'],
      id: data['ID'],
      name: data['name'],
      type: data['type'],
    );
  }

  toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  @override
  String toString() {
    return "WPFile( ${toMap()} )";
  }
}
