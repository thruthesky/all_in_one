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
}
