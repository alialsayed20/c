import '../../../board/domain/models/board_state.dart';
import '../../../session/domain/models/game_session.dart';

class QuizMatchBootstrapData {
  const QuizMatchBootstrapData({
    required this.session,
    required this.board,
  });

  final GameSession session;
  final BoardState board;
}