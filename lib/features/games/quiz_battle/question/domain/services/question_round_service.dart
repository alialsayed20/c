import '../enums/question_round_failure_code.dart';
import '../enums/question_round_status.dart';
import '../models/answer_order_entry.dart';
import '../models/question_round.dart';
import '../models/question_round_failure.dart';
import '../models/question_round_result.dart';

class QuestionRoundService {
  const QuestionRoundService();

  QuestionRoundResult prepare({
    required String questionId,
    required int pointValue,
    required List<String> orderedTeamIds,
    bool isStealBlocked = false,
  }) {
    if (orderedTeamIds.isEmpty) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.emptyAnswerOrder,
        ),
      );
    }

    final List<AnswerOrderEntry> answerOrder = orderedTeamIds
        .map((String teamId) => AnswerOrderEntry(teamId: teamId))
        .toList();

    return QuestionRoundResult.success(
      QuestionRound(
        questionId: questionId,
        pointValue: pointValue,
        status: QuestionRoundStatus.prepared,
        answerOrder: answerOrder,
        currentAnswerIndex: -1,
        isStealBlocked: isStealBlocked,
      ),
    );
  }

  QuestionRoundResult activate(QuestionRound round) {
    if (round.status != QuestionRoundStatus.prepared) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.invalidRoundState,
        ),
      );
    }

    final int firstEligibleIndex = _findNextEligibleIndex(
      answerOrder: round.answerOrder,
      startAfterIndex: -1,
    );

    if (firstEligibleIndex == -1) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.noEligibleTeamToAnswer,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        status: QuestionRoundStatus.answering,
        currentAnswerIndex: firstEligibleIndex,
        currentAnsweringTeamId: round.answerOrder[firstEligibleIndex].teamId,
      ),
    );
  }

  QuestionRoundResult markCurrentTeamAnswered(QuestionRound round) {
    if (round.isResolved) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.roundAlreadyResolved,
        ),
      );
    }

    if (round.status != QuestionRoundStatus.answering ||
        round.currentAnsweringTeamId == null ||
        round.currentAnswerIndex < 0 ||
        round.currentAnswerIndex >= round.answerOrder.length) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.invalidRoundState,
        ),
      );
    }

    final String currentTeamId = round.currentAnsweringTeamId!;

    final List<AnswerOrderEntry> updatedOrder = round.answerOrder
        .map(
          (AnswerOrderEntry entry) => entry.teamId == currentTeamId
              ? entry.copyWith(hasAnswered: true)
              : entry,
        )
        .toList();

    final int nextEligibleIndex = _findNextEligibleIndex(
      answerOrder: updatedOrder,
      startAfterIndex: round.currentAnswerIndex,
    );

    if (nextEligibleIndex == -1) {
      return QuestionRoundResult.success(
        round.copyWith(
          answerOrder: updatedOrder,
          currentAnswerIndex: -1,
          status: QuestionRoundStatus.reveal,
          clearCurrentAnsweringTeamId: true,
          isStealAvailable: !round.isStealBlocked,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        answerOrder: updatedOrder,
        currentAnswerIndex: nextEligibleIndex,
        currentAnsweringTeamId: updatedOrder[nextEligibleIndex].teamId,
      ),
    );
  }

  QuestionRoundResult banTeam({
    required QuestionRound round,
    required String teamId,
  }) {
    if (round.isResolved) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.roundAlreadyResolved,
        ),
      );
    }

    bool found = false;

    final List<AnswerOrderEntry> updatedOrder = round.answerOrder.map((entry) {
      if (entry.teamId != teamId) {
        return entry;
      }

      found = true;
      return entry.copyWith(isBanned: true);
    }).toList();

    if (!found) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.teamNotFound,
        ),
      );
    }

    final bool bannedCurrentTeam = round.currentAnsweringTeamId == teamId;

    if (!bannedCurrentTeam) {
      return QuestionRoundResult.success(
        round.copyWith(answerOrder: updatedOrder),
      );
    }

    final int nextEligibleIndex = _findNextEligibleIndex(
      answerOrder: updatedOrder,
      startAfterIndex: round.currentAnswerIndex,
    );

    if (nextEligibleIndex == -1) {
      return QuestionRoundResult.success(
        round.copyWith(
          answerOrder: updatedOrder,
          currentAnswerIndex: -1,
          status: QuestionRoundStatus.reveal,
          clearCurrentAnsweringTeamId: true,
          isStealAvailable: !round.isStealBlocked,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        answerOrder: updatedOrder,
        currentAnswerIndex: nextEligibleIndex,
        currentAnsweringTeamId: updatedOrder[nextEligibleIndex].teamId,
      ),
    );
  }

  QuestionRoundResult excludeTeam({
    required QuestionRound round,
    required String teamId,
  }) {
    if (round.isResolved) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.roundAlreadyResolved,
        ),
      );
    }

    bool found = false;

    final List<AnswerOrderEntry> updatedOrder = round.answerOrder.map((entry) {
      if (entry.teamId != teamId) {
        return entry;
      }

      found = true;
      return entry.copyWith(isExcluded: true);
    }).toList();

    if (!found) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.teamNotFound,
        ),
      );
    }

    final bool excludedCurrentTeam = round.currentAnsweringTeamId == teamId;

    if (!excludedCurrentTeam) {
      return QuestionRoundResult.success(
        round.copyWith(answerOrder: updatedOrder),
      );
    }

    final int nextEligibleIndex = _findNextEligibleIndex(
      answerOrder: updatedOrder,
      startAfterIndex: round.currentAnswerIndex,
    );

    if (nextEligibleIndex == -1) {
      return QuestionRoundResult.success(
        round.copyWith(
          answerOrder: updatedOrder,
          currentAnswerIndex: -1,
          status: QuestionRoundStatus.reveal,
          clearCurrentAnsweringTeamId: true,
          isStealAvailable: !round.isStealBlocked,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        answerOrder: updatedOrder,
        currentAnswerIndex: nextEligibleIndex,
        currentAnsweringTeamId: updatedOrder[nextEligibleIndex].teamId,
      ),
    );
  }

  QuestionRoundResult stopTeam({
    required QuestionRound round,
    required String teamId,
  }) {
    if (round.isResolved) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.roundAlreadyResolved,
        ),
      );
    }

    if (round.status != QuestionRoundStatus.answering) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.invalidRoundState,
        ),
      );
    }

    bool found = false;

    final List<AnswerOrderEntry> updatedOrder = round.answerOrder.map((entry) {
      if (entry.teamId != teamId) {
        return entry;
      }

      found = true;

      if (!entry.canAnswer) {
        return entry;
      }

      return entry.copyWith(isExcluded: true);
    }).toList();

    if (!found) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.teamNotFound,
        ),
      );
    }

    final AnswerOrderEntry stoppedEntry = updatedOrder.firstWhere(
      (AnswerOrderEntry entry) => entry.teamId == teamId,
    );

    if (!stoppedEntry.isExcluded) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.stopNotAllowed,
        ),
      );
    }

    final bool stoppedCurrentTeam = round.currentAnsweringTeamId == teamId;

    if (!stoppedCurrentTeam) {
      return QuestionRoundResult.success(
        round.copyWith(answerOrder: updatedOrder),
      );
    }

    final int nextEligibleIndex = _findNextEligibleIndex(
      answerOrder: updatedOrder,
      startAfterIndex: round.currentAnswerIndex,
    );

    if (nextEligibleIndex == -1) {
      return QuestionRoundResult.success(
        round.copyWith(
          answerOrder: updatedOrder,
          currentAnswerIndex: -1,
          status: QuestionRoundStatus.reveal,
          clearCurrentAnsweringTeamId: true,
          isStealAvailable: !round.isStealBlocked,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        answerOrder: updatedOrder,
        currentAnswerIndex: nextEligibleIndex,
        currentAnsweringTeamId: updatedOrder[nextEligibleIndex].teamId,
      ),
    );
  }

  QuestionRoundResult enableSteal(QuestionRound round) {
    if (round.isStealBlocked) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.stealBlocked,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(isStealAvailable: true),
    );
  }

  QuestionRoundResult blockSteal(QuestionRound round) {
    return QuestionRoundResult.success(
      round.copyWith(
        isStealBlocked: true,
        isStealAvailable: false,
      ),
    );
  }

  QuestionRoundResult revealAnswer(QuestionRound round) {
    if (round.isResolved) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.roundAlreadyResolved,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        status: QuestionRoundStatus.reveal,
        revealedAnswer: true,
        currentAnswerIndex: -1,
        clearCurrentAnsweringTeamId: true,
      ),
    );
  }

  QuestionRoundResult resolveWithWinner({
    required QuestionRound round,
    required String winnerTeamId,
  }) {
    final bool teamExists =
        round.answerOrder.any((entry) => entry.teamId == winnerTeamId);

    if (!teamExists) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.teamNotFound,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        status: QuestionRoundStatus.resolved,
        winnerTeamId: winnerTeamId,
        revealedAnswer: true,
        currentAnswerIndex: -1,
        clearCurrentAnsweringTeamId: true,
      ),
    );
  }

  QuestionRoundResult moveToReveal(QuestionRound round) {
    if (round.isClosed) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.invalidRoundState,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        status: QuestionRoundStatus.reveal,
        revealedAnswer: true,
        currentAnswerIndex: -1,
        clearCurrentAnsweringTeamId: true,
      ),
    );
  }

  QuestionRoundResult closeRound(QuestionRound round) {
    if (round.isClosed) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.invalidRoundState,
        ),
      );
    }

    return QuestionRoundResult.success(
      round.copyWith(
        status: QuestionRoundStatus.closed,
        isClosed: true,
        currentAnswerIndex: -1,
        clearCurrentAnsweringTeamId: true,
      ),
    );
  }

  QuestionRoundResult stealQuestion({
    required QuestionRound round,
    required String stealingTeamId,
  }) {
    if (round.isResolved) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.roundAlreadyResolved,
        ),
      );
    }

    if (round.status != QuestionRoundStatus.answering) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.invalidRoundState,
        ),
      );
    }

    if (round.isStealBlocked) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.stealBlocked,
        ),
      );
    }

    if (round.answerOrder.isEmpty) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.emptyAnswerOrder,
        ),
      );
    }

    final String originalFirstTeamId = round.answerOrder.first.teamId;

    if (stealingTeamId == originalFirstTeamId) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.invalidStealRequester,
        ),
      );
    }

    final int stealingIndex = round.answerOrder.indexWhere(
      (AnswerOrderEntry entry) => entry.teamId == stealingTeamId,
    );

    if (stealingIndex == -1) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.teamNotFound,
        ),
      );
    }

    final AnswerOrderEntry stealingEntry = round.answerOrder[stealingIndex];

    if (!stealingEntry.canAnswer) {
      return QuestionRoundResult.failure(
        const QuestionRoundFailure(
          code: QuestionRoundFailureCode.invalidStealRequester,
        ),
      );
    }

    final List<AnswerOrderEntry> reorderedAnswerOrder = <AnswerOrderEntry>[
      stealingEntry,
      ...round.answerOrder.where(
        (AnswerOrderEntry entry) => entry.teamId != stealingTeamId,
      ),
    ];

    return QuestionRoundResult.success(
      round.copyWith(
        answerOrder: reorderedAnswerOrder,
        currentAnswerIndex: 0,
        currentAnsweringTeamId: stealingTeamId,
        isStealAvailable: false,
      ),
    );
  }

  int _findNextEligibleIndex({
    required List<AnswerOrderEntry> answerOrder,
    required int startAfterIndex,
  }) {
    if (answerOrder.isEmpty) {
      return -1;
    }

    for (int offset = 1; offset <= answerOrder.length; offset++) {
      final int candidateIndex =
          (startAfterIndex + offset) % answerOrder.length;
      final AnswerOrderEntry candidate = answerOrder[candidateIndex];

      if (candidate.canAnswer) {
        return candidateIndex;
      }
    }

    return -1;
  }
}