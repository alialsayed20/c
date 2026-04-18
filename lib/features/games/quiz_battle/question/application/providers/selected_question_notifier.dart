import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../state/selected_question_state.dart';
import 'question_providers.dart';

class SelectedQuestionNotifier extends StateNotifier<SelectedQuestionState> {
  SelectedQuestionNotifier({
    required QuestionRepository questionRepository,
  })  : _questionRepository = questionRepository,
        super(SelectedQuestionState.idle);

  final QuestionRepository _questionRepository;

  Future<void> loadQuestionById({
    required String questionId,
    required String languageCode,
  }) async {
    state = SelectedQuestionState.loading;

    try {
      final Question? question = await _questionRepository.getQuestionById(
        questionId: questionId,
        languageCode: languageCode,
      );

      if (question == null) {
        state = const SelectedQuestionState(
          isLoading: false,
          errorMessage: 'No question found',
        );
        return;
      }

      state = SelectedQuestionState(
        isLoading: false,
        question: question,
      );
    } catch (_) {
      state = const SelectedQuestionState(
        isLoading: false,
        errorMessage: 'Failed to load question',
      );
    }
  }

  void clear() {
    state = SelectedQuestionState.idle;
  }
}

final StateNotifierProvider<SelectedQuestionNotifier, SelectedQuestionState>
    selectedQuestionNotifierProvider =
    StateNotifierProvider<SelectedQuestionNotifier, SelectedQuestionState>(
  (Ref ref) {
    final QuestionRepository repository = ref.read(questionRepositoryProvider);
    return SelectedQuestionNotifier(
      questionRepository: repository,
    );
  },
);