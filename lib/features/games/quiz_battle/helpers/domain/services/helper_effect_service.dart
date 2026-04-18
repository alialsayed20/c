import '../../../question/domain/models/question_round.dart';
import '../../../question/domain/models/question_round_result.dart';
import '../../../question/domain/services/question_round_service.dart';
import '../enums/helper_effect_failure_code.dart';
import '../enums/helper_type.dart';
import '../enums/helper_usage_status.dart';
import '../models/helper_effect_failure.dart';
import '../models/helper_effect_result.dart';
import '../models/helper_usage.dart';
import '../models/score_modifier_result.dart';

class HelperEffectService {
  const HelperEffectService({
    required QuestionRoundService questionRoundService,
  }) : _questionRoundService = questionRoundService;

  final QuestionRoundService _questionRoundService;

  HelperEffectResult applyToRound({
    required HelperUsage helperUsage,
    required QuestionRound round,
  }) {
    if (helperUsage.status != HelperUsageStatus.activated) {
      return HelperEffectResult.failure(
        const HelperEffectFailure(
          code: HelperEffectFailureCode.helperNotActivated,
        ),
      );
    }

    switch (helperUsage.type) {
      case HelperType.blockSteal:
        final QuestionRoundResult result =
            _questionRoundService.blockSteal(round);

        if (result.isFailure || result.round == null) {
          return HelperEffectResult.failure(
            const HelperEffectFailure(
              code: HelperEffectFailureCode.invalidRoundEffect,
            ),
          );
        }

        return HelperEffectResult.success(result.round!);

      case HelperType.banTeamFromQuestion:
        final String? targetTeamId = helperUsage.targetTeamId;
        if (targetTeamId == null || targetTeamId.trim().isEmpty) {
          return HelperEffectResult.failure(
            const HelperEffectFailure(
              code: HelperEffectFailureCode.invalidRoundEffect,
            ),
          );
        }

        final QuestionRoundResult result = _questionRoundService.banTeam(
          round: round,
          teamId: targetTeamId,
        );

        if (result.isFailure || result.round == null) {
          return HelperEffectResult.failure(
            const HelperEffectFailure(
              code: HelperEffectFailureCode.invalidRoundEffect,
            ),
          );
        }

        return HelperEffectResult.success(result.round!);

      case HelperType.stealQuestion:
        final String? targetTeamId = helperUsage.targetTeamId;
        if (targetTeamId == null || targetTeamId.trim().isEmpty) {
          return HelperEffectResult.failure(
            const HelperEffectFailure(
              code: HelperEffectFailureCode.invalidRoundEffect,
            ),
          );
        }

        final QuestionRoundResult result =
            _questionRoundService.stealQuestion(
          round: round,
          stealingTeamId: targetTeamId,
        );

        if (result.isFailure || result.round == null) {
          return HelperEffectResult.failure(
            const HelperEffectFailure(
              code: HelperEffectFailureCode.invalidRoundEffect,
            ),
          );
        }

        return HelperEffectResult.success(result.round!);

      case HelperType.stopPlayer:
        final String? targetTeamId = helperUsage.targetTeamId;
        if (targetTeamId == null || targetTeamId.trim().isEmpty) {
          return HelperEffectResult.failure(
            const HelperEffectFailure(
              code: HelperEffectFailureCode.invalidRoundEffect,
            ),
          );
        }

        final QuestionRoundResult result = _questionRoundService.stopTeam(
          round: round,
          teamId: targetTeamId,
        );

        if (result.isFailure || result.round == null) {
          return HelperEffectResult.failure(
            const HelperEffectFailure(
              code: HelperEffectFailureCode.invalidRoundEffect,
            ),
          );
        }

        return HelperEffectResult.success(result.round!);

      case HelperType.doublePoints:
        return HelperEffectResult.failure(
          const HelperEffectFailure(
            code: HelperEffectFailureCode.unsupportedHelperType,
          ),
        );
    }
  }

  ScoreModifierResult applyScoreModifier({
    required HelperUsage helperUsage,
    required String winnerTeamId,
    required int baseScore,
  }) {
    if (helperUsage.status != HelperUsageStatus.activated) {
      return ScoreModifierResult(
        score: baseScore,
        isModified: false,
      );
    }

    if (helperUsage.type != HelperType.doublePoints) {
      return ScoreModifierResult(
        score: baseScore,
        isModified: false,
      );
    }

    if (helperUsage.teamId != winnerTeamId) {
      return ScoreModifierResult(
        score: baseScore,
        isModified: false,
      );
    }

    return ScoreModifierResult(
      score: baseScore * 2,
      isModified: true,
    );
  }
}