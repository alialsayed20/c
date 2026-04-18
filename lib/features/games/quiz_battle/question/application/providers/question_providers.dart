import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/local_question_repository.dart';
import '../../domain/repositories/question_repository.dart';

final Provider<QuestionRepository> questionRepositoryProvider =
    Provider<QuestionRepository>((Ref ref) {
  return const LocalQuestionRepository();
});