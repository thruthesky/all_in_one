class ForumModel {
  late int idx;
  late String name;

  ForumModel(Map<String, dynamic> json) {
    idx = json['idx'] ?? 0;
    name = json['name'] ?? '';
  }

  @override
  String toString() => 'ForumModel(name: $name)';

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'name': name,
    };
  }
}
