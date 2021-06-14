class VersionModel {
  final String version;

  const VersionModel(this.version);

  @override
  String toString() => 'VersionModel(version: $version)';

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(json['version'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
    };
  }
}
