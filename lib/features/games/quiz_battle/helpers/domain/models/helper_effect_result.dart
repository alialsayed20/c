import '../../../question/domain/models/question_round.dart';
import 'helper_effect_failure.dart';

class HelperEffectResult {
  const HelperEffectResult._({
    required this.updatedRound,
    required this.failure,
  });

  final QuestionRound? updatedRound;
  final HelperEffectFailure? failure;

  bool get isSuccess => updatedRound != null;
  bool get isFailure => failure != null;

  factory HelperEffectResult.success(QuestionRound updatedRound) {
    return HelperEffectResult._(
      updatedRound: updatedRound,
      failure: null,
    );
  }

  factory HelperEffectResult.failure(HelperEffectFailure failure) {
    return HelperEffectResult._(
      updatedRound: null,
      failure: failure,
    );
  }
}