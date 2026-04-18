import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../categories/application/providers/category_providers.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../question/application/providers/question_providers.dart';
import '../../../question/domain/repositories/question_repository.dart';
import '../services/start_match_service.dart';

final Provider<StartMatchService> startMatchServiceProvider =
    Provider<StartMatchService>((Ref ref) {
  final CategoryRepository categoryRepository =
      ref.read(categoryRepositoryProvider);
  final QuestionRepository questionRepository =
      ref.read(questionRepositoryProvider);

  return StartMatchService(
    categoryRepository: categoryRepository,
    questionRepository: questionRepository,
  );
});