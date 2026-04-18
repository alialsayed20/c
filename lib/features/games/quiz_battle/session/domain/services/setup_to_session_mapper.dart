import '../../../setup/domain/models/player.dart';
import '../../../setup/domain/models/setup_state.dart';
import '../../../setup/domain/models/team.dart';
import '../enums/game_session_status.dart';
import '../models/game_session.dart';
import '../models/session_player_snapshot.dart';
import '../models/session_team_snapshot.dart';
import '../models/start_match_payload.dart';
import '../models/turn_order.dart';

class SetupToSessionMapper {
  const SetupToSessionMapper();

  GameSession map(StartMatchPayload payload) {
    final SetupState setup = payload.setup;

    final List<SessionPlayerSnapshot> players = setup.players.map(
      (Player player) {
        return SessionPlayerSnapshot(
          id: player.id,
          name: player.name,
          teamId: player.teamId!,
          isExcluded: player.isExcluded,
          isEliminated: player.isEliminated,
        );
      },
    ).toList();

    final List<SessionTeamSnapshot> teams = setup.teams.map(
      (Team team) {
        return SessionTeamSnapshot(
          id: team.id,
          name: team.name,
          colorValue: team.colorValue,
          playerIds: List<String>.from(team.playerIds),
        );
      },
    ).toList();

    final List<String> orderedTeamIds = _buildOrderedTeamIds(
      teams: teams,
      startingTeamId: setup.startingTeamId,
    );

    return GameSession(
      id: payload.sessionId,
      status: GameSessionStatus.active,
      teams: teams,
      players: players,
      turnOrder: TurnOrder(
        teamIds: orderedTeamIds,
        currentIndex: orderedTeamIds.isEmpty ? -1 : 0,
      ),
      createdAt: payload.createdAt,
    );
  }

  List<String> _buildOrderedTeamIds({
    required List<SessionTeamSnapshot> teams,
    required String? startingTeamId,
  }) {
    final List<String> baseOrder = teams.map((team) => team.id).toList();

    if (baseOrder.isEmpty || startingTeamId == null) {
      return baseOrder;
    }

    final int startIndex = baseOrder.indexOf(startingTeamId);
    if (startIndex == -1) {
      return baseOrder;
    }

    return <String>[
      ...baseOrder.sublist(startIndex),
      ...baseOrder.sublist(0, startIndex),
    ];
  }
}