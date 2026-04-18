import 'package:uuid/uuid.dart';

import '../../../session/domain/models/game_session.dart';
import '../../../session/domain/models/session_team_snapshot.dart';
import '../../../session/domain/services/session_mutation_service.dart';
import '../enums/penalty_failure_code.dart';
import '../enums/penalty_target_type.dart';
import '../enums/penalty_type.dart';
import '../models/penalty_failure.dart';
import '../models/penalty_record.dart';
import '../models/penalty_result.dart';

class PenaltyService {
  const PenaltyService({
    required SessionMutationService sessionMutationService,
  }) : _sessionMutationService = sessionMutationService;

  final SessionMutationService _sessionMutationService;

  PenaltyResult applyBan({
    required GameSession session,
    required String teamId,
    required int questionValue,
    required String questionId,
  }) {
    final SessionTeamSnapshot? team =
        _findTeam(session: session, teamId: teamId);

    if (team == null) {
      return PenaltyResult.failure(
        const PenaltyFailure(
          code: PenaltyFailureCode.teamNotFound,
        ),
      );
    }

    final int penaltyValue = (questionValue / 2).floor();

    final int newScore = team.score - penaltyValue;

    final updateResult = _sessionMutationService.updateTeamScore(
      session: session,
      teamId: teamId,
      newScore: newScore,
    );

    if (updateResult.session == null) {
      return PenaltyResult.failure(
        const PenaltyFailure(
          code: PenaltyFailureCode.teamNotFound,
        ),
      );
    }

    final PenaltyRecord record = PenaltyRecord(
      id: const Uuid().v4(),
      type: PenaltyType.ban,
      targetType: PenaltyTargetType.team,
      targetId: teamId,
      value: penaltyValue,
      questionId: questionId,
      createdAt: DateTime.now(),
    );

    return PenaltyResult.success(
      session: updateResult.session!,
      record: record,
    );
  }

  PenaltyResult applyCheating({
    required GameSession session,
    required String teamId,
    required int questionValue,
    required String questionId,
  }) {
    final SessionTeamSnapshot? team =
        _findTeam(session: session, teamId: teamId);

    if (team == null) {
      return PenaltyResult.failure(
        const PenaltyFailure(
          code: PenaltyFailureCode.teamNotFound,
        ),
      );
    }

    final int penaltyValue = questionValue;

    final int newScore = team.score - penaltyValue;

    final updateResult = _sessionMutationService.updateTeamScore(
      session: session,
      teamId: teamId,
      newScore: newScore,
    );

    if (updateResult.session == null) {
      return PenaltyResult.failure(
        const PenaltyFailure(
          code: PenaltyFailureCode.teamNotFound,
        ),
      );
    }

    final PenaltyRecord record = PenaltyRecord(
      id: const Uuid().v4(),
      type: PenaltyType.cheating,
      targetType: PenaltyTargetType.team,
      targetId: teamId,
      value: penaltyValue,
      questionId: questionId,
      createdAt: DateTime.now(),
    );

    return PenaltyResult.success(
      session: updateResult.session!,
      record: record,
    );
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