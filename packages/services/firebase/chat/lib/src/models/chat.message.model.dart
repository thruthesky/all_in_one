class ChatMessageModel {
  String text;
  int stamp;

  ChatMessageModel({required this.text, required this.stamp});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(text: json['text'] ?? '', stamp: json['stamp'] ?? 0);
  }

  toJson() {
    return {
      'text': text,
      'stamp': stamp,
    };
  }

  @override
  String toString() {
    return """ChatMessageModel(${toJson()})""";
  }
}
