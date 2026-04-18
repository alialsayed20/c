import '../../domain/models/question.dart';

class SelectedQuestionState {
  const SelectedQuestionState({
    required this.isLoading,
    this.question,
    this.errorMessage,
  });

  final bool isLoading;
  final Question? question;
  final String? errorMessage;

  bool get hasQuestion => question != null;
  bool get hasError =>
      errorMessage != null && errorMessage!.trim().isNotEmpty;

  SelectedQuestionState copyWith({
    bool? isLoading,
    Question? question,
    bool clearQuestion = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SelectedQuestionState(
      isLoading: isLoading ?? this.isLoading,
      question: clearQuestion ? null : (question ?? this.question),
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static const SelectedQuestionState idle = SelectedQuestionState(
    isLoading: false,
  );

  static const SelectedQuestionState loading = SelectedQuestionState(
    isLoading: true,
  );
}