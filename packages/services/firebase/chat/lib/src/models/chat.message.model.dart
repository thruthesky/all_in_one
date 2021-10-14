class ChatMessageModel {
  String text;
  int stamp;
  int newMessages;

  ChatMessageModel({
    required this.text,
    required this.stamp,
    required this.newMessages,
  });

  factory ChatMessageModel.fromJson(Map<dynamic, dynamic> json) {
    return ChatMessageModel(
      text: json['text'] ?? '',
      stamp: json['stamp'] ?? 0,
      newMessages: json['newMessages'] ?? 0,
    );
  }

  toJson() {
    return {
      'text': text,
      'stamp': stamp,
      'newMessages': newMessages,
    };
  }

  @override
  String toString() {
    return """ChatMessageModel(${toJson()})""";
  }
}
