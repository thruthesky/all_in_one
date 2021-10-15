class ChatLoginUser {
  /// [uid] is base uid.
  String uid;
  String name;
  String photoUrl;

  ChatLoginUser({
    required this.uid,
    required this.name,
    required this.photoUrl,
  });

  toJson() {
    return {
      'uid': uid,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  @override
  String toString() {
    return """LoginUser${toJson()}""";
  }
}
