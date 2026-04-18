import 'question_round.dart';
import 'question_round_failure.dart';

class QuestionRoundResult {
  const QuestionRoundResult._({
    required this.round,
    required this.failure,
  });

  final QuestionRound? round;
  final QuestionRoundFailure? failure;

  bool get isSuccess => round != null;
  bool get isFailure => failure != null;

  factory QuestionRoundResult.success(QuestionRound round) {
    return QuestionRoundResult._(
      round: round,
      failure: null,
    );
  }

  factory QuestionRoundResult.failure(QuestionRoundFailure failure) {
    return QuestionRoundResult._(
      round: null,
      failure: failure,
    );
  }
}