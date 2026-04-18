class PenaltyProgressState {
  const PenaltyProgressState({
    required this.teamId,
    required this.warningCount,
    required this.isExcluded,
    required this.skipCurrentQuestion,
    required this.skipNextQuestion,
  });

  final String teamId;
  final int warningCount;
  final bool isExcluded;
  final bool skipCurrentQuestion;
  final bool skipNextQuestion;

  PenaltyProgressState copyWith({
    String? teamId,
    int? warningCount,
    bool? isExcluded,
    bool? skipCurrentQuestion,
    bool? skipNextQuestion,
  }) {
    return PenaltyProgressState(
      teamId: teamId ?? this.teamId,
      warningCount: warningCount ?? this.warningCount,
      isExcluded: isExcluded ?? this.isExcluded,
      skipCurrentQuestion:
          skipCurrentQuestion ?? this.skipCurrentQuestion,
      skipNextQuestion:
          skipNextQuestion ?? this.skipNextQuestion,
    );
  }
}