import 'package:x_flutter/x_flutter.dart';

class FileModel {
  int idx;
  String taxonomy;
  int entity;
  int userIdx;
  String code;
  String path;
  String name;
  String type;
  int size;
  int createdAt;
  int updatedAt;
  String url;

  FileModel({
    this.idx = 0,
    this.taxonomy = '',
    this.entity = 0,
    this.userIdx = 0,
    this.code = '',
    this.path = '',
    this.name = '',
    this.type = '',
    this.size = 0,
    this.createdAt = 0,
    this.updatedAt = 0,
    this.url = '',
  });

  @override
  String toString() {
    return 'FileModel(idx: $idx, taxonomy: $taxonomy, entity: $entity, userIdx: $userIdx, code: $code, path: $path, name: $name, type: $type, size: $size, createdAt: $createdAt, updatedAt: $updatedAt, url: $url)';
  }

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      idx: json['idx'] ?? 0,
      taxonomy: json['taxonomy'] ?? '',
      entity: json['entity'] ?? 0,
      userIdx: json['userIdx'] ?? 0,
      code: json['code'] ?? '',
      path: json['path'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? 0,
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'taxonomy': taxonomy,
      'entity': entity,
      'userIdx': userIdx,
      'code': code,
      'path': path,
      'name': name,
      'type': type,
      'size': size,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'url': url,
    };
  }

  /// 파일 삭제
  ///
  ///
  Future delete([dynamic postOrComment]) {
    return Api.instance.file.delete(idx, postOrComment);
  }
}
