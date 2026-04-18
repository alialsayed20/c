import '../../../board/domain/models/board_action_result.dart';
import '../../../board/domain/models/board_cell.dart';
import '../../../board/domain/models/board_state.dart';
import '../../../board/domain/services/board_service.dart';
import '../../../helpers/domain/enums/helper_type.dart';
import '../../../helpers/domain/enums/helper_usage_status.dart';
import '../../../helpers/domain/models/helper_activation_result.dart';
import '../../../helpers/domain/models/helper_effect_result.dart';
import '../../../helpers/domain/models/helper_usage.dart';
import '../../../helpers/domain/services/helper_effect_service.dart';
import '../../../helpers/domain/services/helper_policy_service.dart';
import '../../../penalties/domain/models/penalty_progress_state.dart';
import '../../../penalties/domain/services/penalty_progress_service.dart';
import '../../../penalties/domain/services/penalty_service.dart';
import '../../../question/domain/models/question_round.dart';
import '../../../question/domain/models/question_round_result.dart';
import '../../../question/domain/services/question_round_service.dart';
import '../../../results/domain/models/scoring_result.dart';
import '../../../results/domain/services/scoring_service.dart';
import '../../../session/domain/models/game_session.dart';
import '../../../session/domain/models/session_mutation_result.dart';
import '../../../session/domain/services/session_mutation_service.dart';
import '../../../session/domain/services/turn_engine_service.dart';
import '../enums/quiz_match_flow_failure_code.dart';
import '../models/quiz_match_flow_action_result.dart';
import '../models/quiz_match_flow_failure.dart';
import '../state/quiz_match_flow_state.dart';

class QuizMatchFlowController {
  const QuizMatchFlowController({
    required TurnEngineService turnEngineService,
    required BoardService boardService,
    required QuestionRoundService questionRoundService,
    required HelperEffectService helperEffectService,
    required ScoringService scoringService,
    required SessionMutationService sessionMutationService,
    required PenaltyService penaltyService,
    required PenaltyProgressService penaltyProgressService,
    required HelperPolicyService helperPolicyService,
  })  : _turnEngineService = turnEngineService,
        _boardService = boardService,
        _questionRoundService = questionRoundService,
        _helperEffectService = helperEffectService,
        _scoringService = scoringService,
        _sessionMutationService = sessionMutationService,
        _penaltyService = penaltyService,
        _penaltyProgressService = penaltyProgressService,
        _helperPolicyService = helperPolicyService;

  final TurnEngineService _turnEngineService;
  final BoardService _boardService;
  final QuestionRoundService _questionRoundService;
  final HelperEffectService _helperEffectService;
  final ScoringService _scoringService;
  final SessionMutationService _sessionMutationService;
  final PenaltyService _penaltyService;
  final PenaltyProgressService _penaltyProgressService;
  final HelperPolicyService _helperPolicyService;

  QuizMatchFlowActionResult startRoundFromCell({
    required QuizMatchFlowState state,
    required String cellId,
    required String questionId,
  }) {
    if (state.hasActiveRound) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundActivationFailed,
        ),
      );
    }

    final String? currentTeamId =
        _turnEngineService.getCurrentTeamId(state.session);

    if (currentTeamId == null || currentTeamId.trim().isEmpty) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.noCurrentTeam,
        ),
      );
    }

    final BoardCell? selectedCell = _findCellById(
      board: state.board,
      cellId: cellId,
    );

    if (selectedCell == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.boardSelectionFailed,
        ),
      );
    }

    final QuestionRoundResult preparedRoundResult =
        _questionRoundService.prepare(
      questionId: questionId,
      pointValue: selectedCell.pointValue,
      orderedTeamIds: state.session.turnOrder.teamIds,
      isStealBlocked: _hasActivatedBoardHelper(
        helperUsages: state.helperUsages,
        helperType: HelperType.blockSteal,
      ),
    );

    if (preparedRoundResult.isFailure || preparedRoundResult.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundPreparationFailed,
        ),
      );
    }

    QuestionRound workingRound = preparedRoundResult.round!;

    final List<HelperUsage> activeRoundHelpers = state.helperUsages
        .where(
          (HelperUsage helper) =>
              helper.status == HelperUsageStatus.activated &&
              helper.relatedQuestionId == questionId,
        )
        .toList();

    for (final HelperUsage helperUsage in activeRoundHelpers) {
      if (helperUsage.type == HelperType.doublePoints) {
        continue;
      }

      final HelperEffectResult effectResult =
          _helperEffectService.applyToRound(
        helperUsage: helperUsage,
        round: workingRound,
      );

      if (effectResult.isFailure || effectResult.updatedRound == null) {
        return QuizMatchFlowActionResult.failure(
          const QuizMatchFlowFailure(
            code: QuizMatchFlowFailureCode.roundActivationFailed,
          ),
        );
      }

      workingRound = effectResult.updatedRound!;
    }

    final QuestionRoundResult activationResult =
        _questionRoundService.activate(workingRound);

    if (activationResult.isFailure || activationResult.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundActivationFailed,
        ),
      );
    }

    final List<HelperUsage> updatedHelpers = _consumeBoardHelperIfActivated(
      helperUsages: state.helperUsages,
      helperType: HelperType.blockSteal,
    );

    return QuizMatchFlowActionResult.success(
      session: state.session,
      board: state.board,
      activeRound: activationResult.round,
      helperUsages: updatedHelpers,
    );
  }

  QuizMatchFlowActionResult activateBoardHelper({
    required QuizMatchFlowState state,
    required String helperId,
    required String relatedQuestionId,
  }) {
    final HelperUsage? helperUsage = _findHelperById(
      helperUsages: state.helperUsages,
      helperId: helperId,
    );

    if (helperUsage == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundActivationFailed,
        ),
      );
    }

    final HelperActivationResult activationResult =
        _helperPolicyService.activateBoardHelper(
      helperUsage: helperUsage,
      relatedQuestionId: relatedQuestionId,
    );

    if (activationResult.isFailure || activationResult.helperUsage == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundActivationFailed,
        ),
      );
    }

    final QuizMatchFlowState updatedState =
        state.replaceHelperUsage(activationResult.helperUsage!);

    return QuizMatchFlowActionResult.success(
      session: updatedState.session,
      board: updatedState.board,
      activeRound: updatedState.activeRound,
      helperUsages: updatedState.helperUsages,
    );
  }

  QuizMatchFlowActionResult revealCurrentRound({
    required QuizMatchFlowState state,
  }) {
    final QuestionRound? activeRound = state.activeRound;

    if (activeRound == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.noActiveRound,
        ),
      );
    }

    final QuestionRoundResult result =
        _questionRoundService.revealAnswer(activeRound);

    if (result.isFailure || result.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundResolutionFailed,
        ),
      );
    }

    return QuizMatchFlowActionResult.success(
      session: state.session,
      board: state.board,
      activeRound: result.round,
      helperUsages: state.helperUsages,
    );
  }

  QuizMatchFlowActionResult resolveActiveRoundWithWinner({
    required QuizMatchFlowState state,
    required String winnerTeamId,
    required String cellId,
  }) {
    final QuestionRound? activeRound = state.activeRound;

    if (activeRound == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.noActiveRound,
        ),
      );
    }

    final QuestionRoundResult roundResult =
        _questionRoundService.resolveWithWinner(
      round: activeRound,
      winnerTeamId: winnerTeamId,
    );

    if (roundResult.isFailure || roundResult.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundResolutionFailed,
        ),
      );
    }

    final QuestionRound resolvedRound = roundResult.round!;

    final ScoringResult scoringResult = _scoringService.scoreResolvedRound(
      session: state.session,
      round: resolvedRound,
      helperUsages: state.helperUsages,
    );

    if (scoringResult.isFailure || scoringResult.updatedSession == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.scoringFailed,
        ),
      );
    }

    final BoardActionResult boardResult = _boardService.markCellAsUsed(
      state: state.board,
      cellId: cellId,
      ownerTeamId: winnerTeamId,
    );

    if (boardResult.isFailure || boardResult.state == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.boardSelectionFailed,
        ),
      );
    }

    final QuestionRoundResult closeResult =
        _questionRoundService.closeRound(resolvedRound);

    if (closeResult.isFailure || closeResult.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundResolutionFailed,
        ),
      );
    }

    final SessionMutationResult advanceResult =
        _sessionMutationService.advanceTurn(
      scoringResult.updatedSession!,
    );

    if (advanceResult.isFailure || advanceResult.session == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.sessionAdvanceFailed,
        ),
      );
    }

    final List<HelperUsage> updatedHelpers = winnerTeamId.isNotEmpty
        ? _consumeBoardHelperIfActivated(
            helperUsages: state.helperUsages,
            helperType: HelperType.doublePoints,
          )
        : state.helperUsages;

    return QuizMatchFlowActionResult.success(
      session: advanceResult.session!,
      board: boardResult.state!,
      activeRound: null,
      helperUsages: updatedHelpers,
    );
  }

  QuizMatchFlowActionResult closeRoundWithoutWinner({
    required QuizMatchFlowState state,
    required String cellId,
  }) {
    final QuestionRound? activeRound = state.activeRound;

    if (activeRound == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.noActiveRound,
        ),
      );
    }

    final QuestionRoundResult revealResult =
        _questionRoundService.moveToReveal(activeRound);

    if (revealResult.isFailure || revealResult.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundResolutionFailed,
        ),
      );
    }

    final QuestionRound revealedRound = revealResult.round!;

    final BoardActionResult boardResult = _boardService.markCellAsUsed(
      state: state.board,
      cellId: cellId,
      ownerTeamId: 'none',
    );

    if (boardResult.isFailure || boardResult.state == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.boardSelectionFailed,
        ),
      );
    }

    final QuestionRoundResult closeResult =
        _questionRoundService.closeRound(revealedRound);

    if (closeResult.isFailure || closeResult.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundResolutionFailed,
        ),
      );
    }

    final SessionMutationResult advanceResult =
        _sessionMutationService.advanceTurn(
      state.session,
    );

    if (advanceResult.isFailure || advanceResult.session == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.sessionAdvanceFailed,
        ),
      );
    }

    return QuizMatchFlowActionResult.success(
      session: advanceResult.session!,
      board: boardResult.state!,
      activeRound: null,
    );
  }

  QuizMatchFlowActionResult applyBan({
    required QuizMatchFlowState state,
    required String teamId,
    required String questionId,
    required int questionValue,
  }) {
    final penaltyResult = _penaltyService.applyBan(
      session: state.session,
      teamId: teamId,
      questionValue: questionValue,
      questionId: questionId,
    );

    if (!penaltyResult.isSuccess || penaltyResult.session == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.scoringFailed,
        ),
      );
    }

    QuestionRound? updatedRound = state.activeRound;

    if (updatedRound != null) {
      final roundResult = _questionRoundService.banTeam(
        round: updatedRound,
        teamId: teamId,
      );

      if (roundResult.isSuccess) {
        updatedRound = roundResult.round;
      }
    }

    return QuizMatchFlowActionResult.success(
      session: penaltyResult.session!,
      board: state.board,
      activeRound: updatedRound,
      helperUsages: state.helperUsages,
    );
  }

  QuizMatchFlowActionResult applyCheating({
    required QuizMatchFlowState state,
    required String teamId,
    required String questionId,
    required int questionValue,
    required PenaltyProgressState progressState,
  }) {
    final penaltyResult = _penaltyService.applyCheating(
      session: state.session,
      teamId: teamId,
      questionValue: questionValue,
      questionId: questionId,
    );

    if (!penaltyResult.isSuccess || penaltyResult.session == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.scoringFailed,
        ),
      );
    }

    GameSession updatedSession = penaltyResult.session!;

    final progressResult = _penaltyProgressService.applyCheatingProgression(
      session: updatedSession,
      currentState: progressState,
    );

    updatedSession = progressResult.session;

    QuestionRound? updatedRound = state.activeRound;

    if (updatedRound != null && progressResult.progressState.isExcluded) {
      final excludeResult = _questionRoundService.excludeTeam(
        round: updatedRound,
        teamId: teamId,
      );

      if (excludeResult.isSuccess) {
        updatedRound = excludeResult.round;
      }
    }

    return QuizMatchFlowActionResult.success(
      session: updatedSession,
      board: state.board,
      activeRound: updatedRound,
      helperUsages: state.helperUsages,
    );
  }

  QuizMatchFlowActionResult markCurrentTeamWrong({
    required QuizMatchFlowState state,
  }) {
    final QuestionRound? activeRound = state.activeRound;

    if (activeRound == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.noActiveRound,
        ),
      );
    }

    final QuestionRoundResult roundResult =
        _questionRoundService.markCurrentTeamAnswered(
      activeRound,
    );

    if (roundResult.isFailure || roundResult.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundResolutionFailed,
        ),
      );
    }

    return QuizMatchFlowActionResult.success(
      session: state.session,
      board: state.board,
      activeRound: roundResult.round,
      helperUsages: state.helperUsages,
    );
  }

  QuizMatchFlowActionResult applyStealQuestion({
    required QuizMatchFlowState state,
    required String stealingTeamId,
  }) {
    final QuestionRound? activeRound = state.activeRound;

    if (activeRound == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.noActiveRound,
        ),
      );
    }

    final bool alreadyUsed = state.helperUsages.any(
      (HelperUsage h) =>
          h.type == HelperType.stealQuestion &&
          h.teamId == stealingTeamId &&
          h.status == HelperUsageStatus.consumed,
    );

    if (alreadyUsed) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundActivationFailed,
        ),
      );
    }

    final QuestionRoundResult result = _questionRoundService.stealQuestion(
      round: activeRound,
      stealingTeamId: stealingTeamId,
    );

    if (result.isFailure || result.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundActivationFailed,
        ),
      );
    }

    final List<HelperUsage> updatedHelpers = _consumeSingleUseHelper(
      helperUsages: state.helperUsages,
      helperType: HelperType.stealQuestion,
      teamId: stealingTeamId,
    );

    return QuizMatchFlowActionResult.success(
      session: state.session,
      board: state.board,
      activeRound: result.round,
      helperUsages: updatedHelpers,
    );
  }

  QuizMatchFlowActionResult applyStopPlayer({
    required QuizMatchFlowState state,
    required String teamId,
  }) {
    final QuestionRound? activeRound = state.activeRound;

    if (activeRound == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.noActiveRound,
        ),
      );
    }

    final String? actingTeamId = _turnEngineService.getCurrentTeamId(
      state.session,
    );

    if (actingTeamId == null || actingTeamId.trim().isEmpty) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.noCurrentTeam,
        ),
      );
    }

    final bool alreadyUsed = state.helperUsages.any(
      (HelperUsage h) =>
          h.type == HelperType.stopPlayer &&
          h.teamId == actingTeamId &&
          h.status == HelperUsageStatus.consumed,
    );

    if (alreadyUsed) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundActivationFailed,
        ),
      );
    }

    final QuestionRoundResult result = _questionRoundService.stopTeam(
      round: activeRound,
      teamId: teamId,
    );

    if (result.isFailure || result.round == null) {
      return QuizMatchFlowActionResult.failure(
        const QuizMatchFlowFailure(
          code: QuizMatchFlowFailureCode.roundActivationFailed,
        ),
      );
    }

    final List<HelperUsage> updatedHelpers = _consumeSingleUseHelper(
      helperUsages: state.helperUsages,
      helperType: HelperType.stopPlayer,
      teamId: actingTeamId,
    );

    return QuizMatchFlowActionResult.success(
      session: state.session,
      board: state.board,
      activeRound: result.round,
      helperUsages: updatedHelpers,
    );
  }

  BoardCell? _findCellById({
    required BoardState board,
    required String cellId,
  }) {
    for (final column in board.columns) {
      for (final cell in column.cells) {
        if (cell.id == cellId) {
          return cell;
        }
      }
    }

    return null;
  }

  HelperUsage? _findHelperById({
    required List<HelperUsage> helperUsages,
    required String helperId,
  }) {
    for (final HelperUsage helperUsage in helperUsages) {
      if (helperUsage.id == helperId) {
        return helperUsage;
      }
    }

    return null;
  }

  bool _hasActivatedBoardHelper({
    required List<HelperUsage> helperUsages,
    required HelperType helperType,
  }) {
    return helperUsages.any(
      (HelperUsage helper) =>
          helper.type == helperType &&
          helper.status == HelperUsageStatus.activated,
    );
  }

  List<HelperUsage> _consumeBoardHelperIfActivated({
    required List<HelperUsage> helperUsages,
    required HelperType helperType,
  }) {
    return helperUsages.map((HelperUsage helper) {
      if (helper.type == helperType &&
          helper.status == HelperUsageStatus.activated) {
        return helper.copyWith(
          status: HelperUsageStatus.consumed,
        );
      }

      return helper;
    }).toList();
  }

  List<HelperUsage> _consumeSingleUseHelper({
    required List<HelperUsage> helperUsages,
    required HelperType helperType,
    required String teamId,
  }) {
    return helperUsages.map((HelperUsage helper) {
      if (helper.type == helperType &&
          helper.teamId == teamId &&
          helper.status != HelperUsageStatus.consumed) {
        return helper.copyWith(
          status: HelperUsageStatus.consumed,
        );
      }

      return helper;
    }).toList();
  }
}