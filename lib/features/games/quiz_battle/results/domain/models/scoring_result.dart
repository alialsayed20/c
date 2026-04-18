import '../../../session/domain/models/game_session.dart';
import 'match_score_entry.dart';
import 'scoring_failure.dart';

class ScoringResult {
  const ScoringResult._({
    required this.updatedSession,
    required this.scoreEntry,
    required this.failure,
  });

  final GameSession? updatedSession;
  final MatchScoreEntry? scoreEntry;
  final ScoringFailure? failure;

  bool get isSuccess => updatedSession != null && scoreEntry != null;
  bool get isFailure => failure != null;

  factory ScoringResult.success({
    required GameSession updatedSession,
    required MatchScoreEntry scoreEntry,
  }) {
    return ScoringResult._(
      updatedSession: updatedSession,
      scoreEntry: scoreEntry,
      failure: null,
    );
  }

  factory ScoringResult.failure(ScoringFailure failure) {
    return ScoringResult._(
      updatedSession: null,
      scoreEntry: null,
      failure: failure,
    );
  }
}