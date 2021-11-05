import '../wordpress.dart';

class QuestionApi {
  /// Singleton
  static QuestionApi? _instance;
  static QuestionApi get instance {
    if (_instance == null) {
      _instance = QuestionApi();
    }
    return _instance!;
  }

  Future<WPQuestion> nextQuestion() async {
    final res = await WordpressApi.instance.request('question.nextQuestion');
    return WPQuestion.fromJson(res);
  }

  Future<WPQuestionTestResult> testResult() async {
    final res = await WordpressApi.instance.request('question.testResult');
    return WPQuestionTestResult.fromJson(res);
  }

  Future<int> recordHistory({
    required int questionId,
    required String answer,
    required String result,
  }) async {
    final res = await WordpressApi.instance.request(
      'question.recordHistory',
      data: {
        'question_ID': questionId,
        'answer': answer,
        'result': result,
      },
    );
    return res['question_ID'];
  }
}
