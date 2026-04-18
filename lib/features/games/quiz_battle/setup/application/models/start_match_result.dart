import '../../../board/domain/models/board_state.dart';
import '../../../session/domain/models/game_session.dart';

class StartMatchResult {
  const StartMatchResult._({
    required this.session,
    required this.board,
    required this.errorMessage,
  });

  final GameSession? session;
  final BoardState? board;
  final String? errorMessage;

  bool get isSuccess => session != null && board != null;
  bool get isFailure => errorMessage != null;

  factory StartMatchResult.success({
    required GameSession session,
    required BoardState board,
  }) {
    return StartMatchResult._(
      session: session,
      board: board,
      errorMessage: null,
    );
  }

  factory StartMatchResult.failure(String errorMessage) {
    return StartMatchResult._(
      session: null,
      board: null,
      errorMessage: errorMessage,
    );
  }
}