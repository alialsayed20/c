import 'game_session.dart';
import 'session_mutation_failure.dart';

class SessionMutationResult {
  const SessionMutationResult._({
    required this.session,
    required this.failure,
  });

  final GameSession? session;
  final SessionMutationFailure? failure;

  bool get isSuccess => session != null;
  bool get isFailure => failure != null;

  factory SessionMutationResult.success(GameSession session) {
    return SessionMutationResult._(
      session: session,
      failure: null,
    );
  }

  factory SessionMutationResult.failure(SessionMutationFailure failure) {
    return SessionMutationResult._(
      session: null,
      failure: failure,
    );
  }
}