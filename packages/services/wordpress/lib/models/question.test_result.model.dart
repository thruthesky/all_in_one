import 'package:wordpress/wordpress.dart';

class WPQuestionTestResult {
  int noOfQuestionTaken, noOfCorrectAnswer, noOfWrongAnswer, score;

  WPQuestionTestResult({
    required this.noOfQuestionTaken,
    required this.noOfCorrectAnswer,
    required this.noOfWrongAnswer,
    required this.score,
  });

  factory WPQuestionTestResult.fromJson(MapStringDynamic data) {
    return WPQuestionTestResult(
      noOfQuestionTaken: toInt(data['noOfQuestionTaken']),
      noOfCorrectAnswer: toInt(data['noOfCorrectAnswer']),
      noOfWrongAnswer: toInt(data['noOfWrongAnswer']),
      score: toInt(data['score']),
    );
  }

  toMap() {
    return {
      'noOfQuestionTaken': noOfQuestionTaken,
      'noOfCorrectAnswer': noOfCorrectAnswer,
      'noOfWrongAnswer': noOfWrongAnswer,
      'score': score,
    };
  }

  @override
  String toString() {
    return "WPQuestionTestResult( ${toMap()} )";
  }
}
