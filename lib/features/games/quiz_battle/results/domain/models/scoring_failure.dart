import '../enums/scoring_failure_code.dart';

class ScoringFailure {
  const ScoringFailure({
    required this.code,
  });

  final ScoringFailureCode code;
}