import '../../../board/domain/models/board_state.dart';
import '../../../helpers/domain/enums/helper_scope.dart';
import '../../../helpers/domain/enums/helper_type.dart';
import '../../../helpers/domain/enums/helper_usage_status.dart';
import '../../../helpers/domain/models/helper_usage.dart';
import '../../../session/domain/models/game_session.dart';
import '../state/quiz_match_flow_state.dart';

class QuizMatchInitialStateFactory {
  const QuizMatchInitialStateFactory();

  QuizMatchFlowState create({
    required GameSession session,
    required BoardState board,
  }) {
    final String currentTeamId =
        session.currentTeamId ?? 'current_team';

    return QuizMatchFlowState(
      session: session,
      board: board,
      helperUsages: <HelperUsage>[
        HelperUsage(
          id: 'board_block_steal',
          teamId: currentTeamId,
          type: HelperType.blockSteal,
          scope: HelperScope.board,
          status: HelperUsageStatus.ready,
        ),
        HelperUsage(
          id: 'board_double_points',
          teamId: currentTeamId,
          type: HelperType.doublePoints,
          scope: HelperScope.board,
          status: HelperUsageStatus.ready,
        ),
      ],
    );
  }
}