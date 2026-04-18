import '../enums/question_round_status.dart';
import 'answer_order_entry.dart';

class QuestionRound {
  const QuestionRound({
    required this.questionId,
    required this.pointValue,
    required this.status,
    required this.answerOrder,
    required this.currentAnswerIndex,
    this.currentAnsweringTeamId,
    this.winnerTeamId,
    this.revealedAnswer = false,
    this.isStealAvailable = false,
    this.isStealBlocked = false,
    this.isClosed = false,
  });

  final String questionId;
  final int pointValue;
  final QuestionRoundStatus status;
  final List<AnswerOrderEntry> answerOrder;
  final int currentAnswerIndex;
  final String? currentAnsweringTeamId;
  final String? winnerTeamId;
  final bool revealedAnswer;
  final bool isStealAvailable;
  final bool isStealBlocked;
  final bool isClosed;

  bool get isResolved => status == QuestionRoundStatus.resolved;
  bool get isRevealPhase => status == QuestionRoundStatus.reveal;

  QuestionRound copyWith({
    String? questionId,
    int? pointValue,
    QuestionRoundStatus? status,
    List<AnswerOrderEntry>? answerOrder,
    int? currentAnswerIndex,
    String? currentAnsweringTeamId,
    bool clearCurrentAnsweringTeamId = false,
    String? winnerTeamId,
    bool clearWinnerTeamId = false,
    bool? revealedAnswer,
    bool? isStealAvailable,
    bool? isStealBlocked,
    bool? isClosed,
  }) {
    return QuestionRound(
      questionId: questionId ?? this.questionId,
      pointValue: pointValue ?? this.pointValue,
      status: status ?? this.status,
      answerOrder: answerOrder ?? this.answerOrder,
      currentAnswerIndex: currentAnswerIndex ?? this.currentAnswerIndex,
      currentAnsweringTeamId: clearCurrentAnsweringTeamId
          ? null
          : (currentAnsweringTeamId ?? this.currentAnsweringTeamId),
      winnerTeamId:
          clearWinnerTeamId ? null : (winnerTeamId ?? this.winnerTeamId),
      revealedAnswer: revealedAnswer ?? this.revealedAnswer,
      isStealAvailable: isStealAvailable ?? this.isStealAvailable,
      isStealBlocked: isStealBlocked ?? this.isStealBlocked,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}