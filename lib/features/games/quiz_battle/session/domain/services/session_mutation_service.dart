import '../enums/game_session_status.dart';
import '../enums/session_mutation_failure_code.dart';
import '../models/game_session.dart';
import '../models/session_mutation_failure.dart';
import '../models/session_mutation_result.dart';
import '../models/session_team_snapshot.dart';
import 'turn_engine_service.dart';

class SessionMutationService {
  const SessionMutationService({
    required TurnEngineService turnEngineService,
  }) : _turnEngineService = turnEngineService;

  final TurnEngineService _turnEngineService;

  SessionMutationResult advanceTurn(GameSession session) {
    final advanceResult = _turnEngineService.advance(session);

    if (advanceResult.isFailure || advanceResult.turnOrder == null) {
      return SessionMutationResult.failure(
        const SessionMutationFailure(
          code: SessionMutationFailureCode.turnAdvanceFailed,
        ),
      );
    }

    return SessionMutationResult.success(
      session.copyWith(
        turnOrder: advanceResult.turnOrder,
      ),
    );
  }

  SessionMutationResult updateTeamScore({
    required GameSession session,
    required String teamId,
    required int newScore,
  }) {
    bool found = false;

    final List<SessionTeamSnapshot> updatedTeams = session.teams.map((team) {
      if (team.id != teamId) {
        return team;
      }

      found = true;
      return team.copyWith(score: newScore);
    }).toList();

    if (!found) {
      return SessionMutationResult.failure(
        const SessionMutationFailure(
          code: SessionMutationFailureCode.teamNotFound,
        ),
      );
    }

    return SessionMutationResult.success(
      session.copyWith(teams: updatedTeams),
    );
  }

  SessionMutationResult eliminateTeam({
    required GameSession session,
    required String teamId,
  }) {
    bool found = false;

    final List<SessionTeamSnapshot> updatedTeams = session.teams.map((team) {
      if (team.id != teamId) {
        return team;
      }

      found = true;
      return team.copyWith(isEliminated: true);
    }).toList();

    if (!found) {
      return SessionMutationResult.failure(
        const SessionMutationFailure(
          code: SessionMutationFailureCode.teamNotFound,
        ),
      );
    }

    return SessionMutationResult.success(
      session.copyWith(teams: updatedTeams),
    );
  }

  GameSession setStatus({
    required GameSession session,
    required GameSessionStatus status,
  }) {
    return session.copyWith(status: status);
  }
}