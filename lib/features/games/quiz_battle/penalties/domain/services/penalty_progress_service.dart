import '../../../session/domain/enums/game_session_status.dart';
import '../../../session/domain/models/game_session.dart';
import '../../../session/domain/models/session_team_snapshot.dart';
import '../../../session/domain/services/session_mutation_service.dart';
import '../models/penalty_progress_result.dart';
import '../models/penalty_progress_state.dart';

class PenaltyProgressService {
  const PenaltyProgressService({
    required SessionMutationService sessionMutationService,
  }) : _sessionMutationService = sessionMutationService;

  final SessionMutationService _sessionMutationService;

  PenaltyProgressResult applyCheatingProgression({
    required GameSession session,
    required PenaltyProgressState currentState,
  }) {
    final int newWarnings = currentState.warningCount + 1;

    // 🚨 الحالة: إنذار أول
    if (newWarnings == 1) {
      return PenaltyProgressResult(
        session: session,
        progressState: currentState.copyWith(
          warningCount: newWarnings,
          skipCurrentQuestion: true,
          skipNextQuestion: true,
        ),
        matchEnded: false,
      );
    }

    // 🚨 الحالة: إنذار ثاني → Exclude
    final SessionTeamSnapshot? team =
        _findTeam(session: session, teamId: currentState.teamId);

    if (team == null) {
      return PenaltyProgressResult(
        session: session,
        progressState: currentState,
        matchEnded: false,
      );
    }

    final eliminateResult =
        _sessionMutationService.eliminateTeam(
      session: session,
      teamId: team.id,
    );

    final GameSession updatedSession = eliminateResult.session!;

    final bool matchEnded =
        _checkIfMatchEnded(updatedSession);

    final GameSession finalSession = matchEnded
        ? _sessionMutationService.setStatus(
            session: updatedSession,
            status: GameSessionStatus.finished,
          )
        : updatedSession;

    return PenaltyProgressResult(
      session: finalSession,
      progressState: currentState.copyWith(
        warningCount: newWarnings,
        isExcluded: true,
        skipCurrentQuestion: true,
        skipNextQuestion: true,
      ),
      matchEnded: matchEnded,
    );
  }

  bool _checkIfMatchEnded(GameSession session) {
    final List<SessionTeamSnapshot> activeTeams = session.teams
        .where((team) => !team.isEliminated)
        .toList();

    return activeTeams.length <= 1;
  }

  SessionTeamSnapshot? _findTeam({
    required GameSession session,
    required String teamId,
  }) {
    for (final team in session.teams) {
      if (team.id == teamId) {
        return team;
      }
    }
    return null;
  }
}