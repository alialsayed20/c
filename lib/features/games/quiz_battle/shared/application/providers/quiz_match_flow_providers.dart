import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../board/domain/services/board_service.dart';
import '../../../helpers/domain/enums/helper_scope.dart';
import '../../../helpers/domain/enums/helper_type.dart';
import '../../../helpers/domain/enums/helper_usage_status.dart';
import '../../../helpers/domain/models/helper_usage.dart';
import '../../../helpers/domain/services/helper_effect_service.dart';
import '../../../helpers/domain/services/helper_policy_service.dart';
import '../../../penalties/domain/models/penalty_progress_state.dart';
import '../../../penalties/domain/services/penalty_progress_service.dart';
import '../../../penalties/domain/services/penalty_service.dart';
import '../../../question/domain/services/question_round_service.dart';
import '../../../results/domain/services/scoring_service.dart';
import '../../../session/domain/services/session_mutation_service.dart';
import '../../../session/domain/services/turn_engine_service.dart';
import '../controllers/quiz_match_flow_controller.dart';
import '../models/quiz_match_bootstrap_data.dart';
import '../state/quiz_match_flow_state.dart';

final Provider<QuizMatchFlowController> quizMatchFlowControllerProvider =
    Provider<QuizMatchFlowController>((Ref ref) {
  return QuizMatchFlowController(
    turnEngineService: const TurnEngineService(),
    boardService: const BoardService(),
    questionRoundService: const QuestionRoundService(),
    helperEffectService: const HelperEffectService(
      questionRoundService: QuestionRoundService(),
    ),
    scoringService: ScoringService(
      sessionMutationService: const SessionMutationService(
        turnEngineService: TurnEngineService(),
      ),
      helperEffectService: const HelperEffectService(
        questionRoundService: QuestionRoundService(),
      ),
    ),
    sessionMutationService: const SessionMutationService(
      turnEngineService: TurnEngineService(),
    ),
    penaltyService: PenaltyService(
      sessionMutationService: const SessionMutationService(
        turnEngineService: TurnEngineService(),
      ),
    ),
    penaltyProgressService: PenaltyProgressService(
      sessionMutationService: const SessionMutationService(
        turnEngineService: TurnEngineService(),
      ),
    ),
    helperPolicyService: const HelperPolicyService(),
  );
});

class QuizMatchFlowNotifier extends StateNotifier<QuizMatchFlowState> {
  QuizMatchFlowNotifier({
    required QuizMatchFlowState initialState,
    required QuizMatchFlowController controller,
  })  : _controller = controller,
        super(initialState);

  final QuizMatchFlowController _controller;

  void startRound({
    required String cellId,
    required String questionId,
  }) {
    final result = _controller.startRoundFromCell(
      state: state,
      cellId: cellId,
      questionId: questionId,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        board: result.board!,
        activeRound: result.activeRound,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void activateBoardHelper({
    required String helperId,
    required String relatedQuestionId,
  }) {
    final result = _controller.activateBoardHelper(
      state: state,
      helperId: helperId,
      relatedQuestionId: relatedQuestionId,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        board: result.board!,
        activeRound: result.activeRound,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void revealCurrentRound() {
    final result = _controller.revealCurrentRound(
      state: state,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        board: result.board!,
        activeRound: result.activeRound,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void resolveRound({
    required String winnerTeamId,
    required String cellId,
  }) {
    final result = _controller.resolveActiveRoundWithWinner(
      state: state,
      winnerTeamId: winnerTeamId,
      cellId: cellId,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        board: result.board!,
        clearActiveRound: true,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void closeRoundWithoutWinner({
    required String cellId,
  }) {
    final result = _controller.closeRoundWithoutWinner(
      state: state,
      cellId: cellId,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        board: result.board!,
        clearActiveRound: true,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void applyBan({
    required String teamId,
    required String questionId,
    required int questionValue,
  }) {
    final result = _controller.applyBan(
      state: state,
      teamId: teamId,
      questionId: questionId,
      questionValue: questionValue,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        activeRound: result.activeRound,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void applyCheating({
    required String teamId,
    required String questionId,
    required int questionValue,
    required PenaltyProgressState progressState,
  }) {
    final result = _controller.applyCheating(
      state: state,
      teamId: teamId,
      questionId: questionId,
      questionValue: questionValue,
      progressState: progressState,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        activeRound: result.activeRound,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void markCurrentTeamWrong() {
    final result = _controller.markCurrentTeamWrong(
      state: state,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        board: result.board!,
        activeRound: result.activeRound,
        clearActiveRound: result.activeRound == null,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void applyStealQuestion({
    required String stealingTeamId,
  }) {
    final result = _controller.applyStealQuestion(
      state: state,
      stealingTeamId: stealingTeamId,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        board: result.board!,
        activeRound: result.activeRound,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }

  void applyStopPlayer({
    required String teamId,
  }) {
    final result = _controller.applyStopPlayer(
      state: state,
      teamId: teamId,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        session: result.session!,
        board: result.board!,
        activeRound: result.activeRound,
        helperUsages: result.helperUsages ?? state.helperUsages,
      );
    }
  }
}

final quizMatchFlowNotifierProvider = StateNotifierProvider.family<
    QuizMatchFlowNotifier,
    QuizMatchFlowState,
    QuizMatchBootstrapData>(
  (ref, bootstrap) {
    final QuizMatchFlowController controller =
        ref.read(quizMatchFlowControllerProvider);

    return QuizMatchFlowNotifier(
      controller: controller,
      initialState: QuizMatchFlowState(
        session: bootstrap.session,
        board: bootstrap.board,
        helperUsages: _initialBoardHelpers(bootstrap),
      ),
    );
  },
);

List<HelperUsage> _initialBoardHelpers(
  QuizMatchBootstrapData bootstrap,
) {
  final List<HelperUsage> helpers = [];

  for (final team in bootstrap.session.teams) {
    helpers.addAll([
      HelperUsage(
        id: 'block_steal_${team.id}',
        teamId: team.id,
        type: HelperType.blockSteal,
        scope: HelperScope.board,
        status: HelperUsageStatus.ready,
      ),
      HelperUsage(
        id: 'double_points_${team.id}',
        teamId: team.id,
        type: HelperType.doublePoints,
        scope: HelperScope.board,
        status: HelperUsageStatus.ready,
      ),
    ]);
  }

  return helpers;
}