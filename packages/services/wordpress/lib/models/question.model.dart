import 'package:wordpress/wordpress.dart';

import '../defines.dart';

class WPQuestion {
  int id;
  String question, a, b, c, d, e, answer;

  WPQuestion({
    required this.id,
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
    required this.answer,
  });

  factory WPQuestion.fromJson(MapStringDynamic data) {
    return WPQuestion(
      id: toInt(data['ID']),
      question: data['question'] ?? '',
      a: data['a'] ?? '',
      b: data['b'] ?? '',
      c: data['c'] ?? '',
      d: data['d'] ?? '',
      e: data['e'] ?? '',
      answer: data['answer'] ?? '',
    );
  }

  toMap() {
    return {
      'id': id,
      'question': question,
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'e': e,
      'answer': answer,
    };
  }

  @override
  String toString() {
    return "WPQuestion( ${toMap()} )";
  }
}
