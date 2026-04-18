import 'game_session.dart';
import 'start_match_failure.dart';

class StartMatchResult {
  const StartMatchResult._({
    required this.session,
    required this.failure,
  });

  final GameSession? session;
  final StartMatchFailure? failure;

  bool get isSuccess => session != null;
  bool get isFailure => failure != null;

  factory StartMatchResult.success(GameSession session) {
    return StartMatchResult._(
      session: session,
      failure: null,
    );
  }

  factory StartMatchResult.failure(StartMatchFailure failure) {
    return StartMatchResult._(
      session: null,
      failure: failure,
    );
  }
}