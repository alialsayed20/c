import '../../../board/domain/models/board_state.dart';
import '../../../helpers/domain/models/helper_usage.dart';
import '../../../question/domain/models/question_round.dart';
import '../../../session/domain/models/game_session.dart';
import 'quiz_match_flow_failure.dart';

class QuizMatchFlowActionResult {
  const QuizMatchFlowActionResult._({
    required this.session,
    required this.board,
    required this.activeRound,
    required this.helperUsages,
    required this.failure,
  });

  final GameSession? session;
  final BoardState? board;
  final QuestionRound? activeRound;
  final List<HelperUsage>? helperUsages;
  final QuizMatchFlowFailure? failure;

  bool get isSuccess => session != null && board != null;
  bool get isFailure => failure != null;

  factory QuizMatchFlowActionResult.success({
    required GameSession session,
    required BoardState board,
    QuestionRound? activeRound,
    List<HelperUsage>? helperUsages,
  }) {
    return QuizMatchFlowActionResult._(
      session: session,
      board: board,
      activeRound: activeRound,
      helperUsages: helperUsages,
      failure: null,
    );
  }

  factory QuizMatchFlowActionResult.failure(
    QuizMatchFlowFailure failure,
  ) {
    return QuizMatchFlowActionResult._(
      session: null,
      board: null,
      activeRound: null,
      helperUsages: null,
      failure: failure,
    );
  }
}