import '../models/question.dart';

abstract interface class QuestionRepository {
  Future<List<Question>> getQuestionsByCategory({
    required String categoryId,
    required String languageCode,
  });

  Future<Question?> getQuestionById({
    required String questionId,
    required String languageCode,
  });
}