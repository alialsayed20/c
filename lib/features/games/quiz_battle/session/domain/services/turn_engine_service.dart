import '../enums/turn_advance_failure_code.dart';
import '../models/game_session.dart';
import '../models/session_team_snapshot.dart';
import '../models/turn_advance_failure.dart';
import '../models/turn_advance_result.dart';
import '../models/turn_order.dart';

class TurnEngineService {
  const TurnEngineService();

  String? getCurrentTeamId(GameSession session) {
    return session.turnOrder.currentTeamId;
  }

  TurnAdvanceResult advance(GameSession session) {
    final TurnOrder turnOrder = session.turnOrder;

    if (turnOrder.teamIds.isEmpty) {
      return TurnAdvanceResult.failure(
        const TurnAdvanceFailure(
          code: TurnAdvanceFailureCode.emptyTurnOrder,
        ),
      );
    }

    if (turnOrder.currentIndex < 0 ||
        turnOrder.currentIndex >= turnOrder.teamIds.length) {
      return TurnAdvanceResult.failure(
        const TurnAdvanceFailure(
          code: TurnAdvanceFailureCode.invalidCurrentIndex,
        ),
      );
    }

    final Set<String> eligibleTeamIds = session.teams
        .where((SessionTeamSnapshot team) => !team.isEliminated)
        .map((SessionTeamSnapshot team) => team.id)
        .toSet();

    if (eligibleTeamIds.isEmpty) {
      return TurnAdvanceResult.failure(
        const TurnAdvanceFailure(
          code: TurnAdvanceFailureCode.noEligibleTeams,
        ),
      );
    }

    final int nextIndex = _findNextEligibleIndex(
      teamIds: turnOrder.teamIds,
      currentIndex: turnOrder.currentIndex,
      eligibleTeamIds: eligibleTeamIds,
    );

    if (nextIndex == -1) {
      return TurnAdvanceResult.failure(
        const TurnAdvanceFailure(
          code: TurnAdvanceFailureCode.noEligibleTeams,
        ),
      );
    }

    return TurnAdvanceResult.success(
      turnOrder.copyWith(currentIndex: nextIndex),
    );
  }

  int _findNextEligibleIndex({
    required List<String> teamIds,
    required int currentIndex,
    required Set<String> eligibleTeamIds,
  }) {
    if (teamIds.isEmpty) {
      return -1;
    }

    for (int offset = 1; offset <= teamIds.length; offset++) {
      final int candidateIndex = (currentIndex + offset) % teamIds.length;
      final String candidateTeamId = teamIds[candidateIndex];

      if (eligibleTeamIds.contains(candidateTeamId)) {
        return candidateIndex;
      }
    }

    return -1;
  }
}