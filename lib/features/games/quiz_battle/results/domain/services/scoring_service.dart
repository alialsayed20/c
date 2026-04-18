import '../../../helpers/domain/models/helper_usage.dart';
import '../../../helpers/domain/models/score_modifier_result.dart';
import '../../../helpers/domain/services/helper_effect_service.dart';
import '../../../question/domain/models/question_round.dart';
import '../../../session/domain/models/game_session.dart';
import '../../../session/domain/models/session_team_snapshot.dart';
import '../../../session/domain/services/session_mutation_service.dart';
import '../enums/scoring_failure_code.dart';
import '../models/match_score_entry.dart';
import '../models/scoring_failure.dart';
import '../models/scoring_result.dart';

class ScoringService {
  const ScoringService({
    required SessionMutationService sessionMutationService,
    required HelperEffectService helperEffectService,
  })  : _sessionMutationService = sessionMutationService,
        _helperEffectService = helperEffectService;

  final SessionMutationService _sessionMutationService;
  final HelperEffectService _helperEffectService;

  ScoringResult scoreResolvedRound({
    required GameSession session,
    required QuestionRound round,
    List<HelperUsage> helperUsages = const <HelperUsage>[],
  }) {
    if (!round.isResolved || round.winnerTeamId == null) {
      return ScoringResult.failure(
        const ScoringFailure(
          code: ScoringFailureCode.roundNotResolved,
        ),
      );
    }

    final String winnerTeamId = round.winnerTeamId!;

    final SessionTeamSnapshot? winnerTeam = _findTeamById(
      session: session,
      teamId: winnerTeamId,
    );

    if (winnerTeam == null) {
      return ScoringResult.failure(
        const ScoringFailure(
          code: ScoringFailureCode.teamNotFoundInSession,
        ),
      );
    }

    final int baseScore = round.pointValue;

    int finalScore = baseScore;
    bool isModified = false;

    for (final HelperUsage helperUsage in helperUsages) {
      final ScoreModifierResult modifierResult =
          _helperEffectService.applyScoreModifier(
        helperUsage: helperUsage,
        winnerTeamId: winnerTeamId,
        baseScore: finalScore,
      );

      finalScore = modifierResult.score;
      isModified = isModified || modifierResult.isModified;
    }

    final updateResult = _sessionMutationService.updateTeamScore(
      session: session,
      teamId: winnerTeamId,
      newScore: winnerTeam.score + finalScore,
    );

    if (updateResult.isFailure || updateResult.session == null) {
      return ScoringResult.failure(
        const ScoringFailure(
          code: ScoringFailureCode.winnerNotFound,
        ),
      );
    }

    return ScoringResult.success(
      updatedSession: updateResult.session!,
      scoreEntry: MatchScoreEntry(
        teamId: winnerTeamId,
        baseScore: baseScore,
        finalScore: finalScore,
        isModified: isModified,
      ),
    );
  }

  SessionTeamSnapshot? _findTeamById({
    required GameSession session,
    required String teamId,
  }) {
    for (final SessionTeamSnapshot team in session.teams) {
      if (team.id == teamId) {
        return team;
      }
    }

    return null;
  }
}