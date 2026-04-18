import '../../../board/domain/models/board_state.dart';
import '../../../helpers/domain/models/helper_usage.dart';
import '../../../question/domain/models/question_round.dart';
import '../../../session/domain/models/game_session.dart';

class QuizMatchFlowState {
  const QuizMatchFlowState({
    required this.session,
    required this.board,
    required this.helperUsages,
    this.activeRound,
  });

  final GameSession session;
  final BoardState board;
  final List<HelperUsage> helperUsages;
  final QuestionRound? activeRound;

  bool get hasActiveRound => activeRound != null;

  QuizMatchFlowState copyWith({
    GameSession? session,
    BoardState? board,
    List<HelperUsage>? helperUsages,
    QuestionRound? activeRound,
    bool clearActiveRound = false,
  }) {
    return QuizMatchFlowState(
      session: session ?? this.session,
      board: board ?? this.board,
      helperUsages: helperUsages ?? this.helperUsages,
      activeRound: clearActiveRound ? null : (activeRound ?? this.activeRound),
    );
  }

  QuizMatchFlowState replaceHelperUsage(HelperUsage updatedHelperUsage) {
    final List<HelperUsage> updatedHelpers = helperUsages
        .map((HelperUsage helperUsage) {
          if (helperUsage.id == updatedHelperUsage.id) {
            return updatedHelperUsage;
          }
          return helperUsage;
        })
        .toList();

    return copyWith(helperUsages: updatedHelpers);
  }

  QuizMatchFlowState replaceHelperUsages(List<HelperUsage> updatedHelperUsages) {
    return copyWith(helperUsages: updatedHelperUsages);
  }
}