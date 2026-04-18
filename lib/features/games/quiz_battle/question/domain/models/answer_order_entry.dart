class AnswerOrderEntry {
  const AnswerOrderEntry({
    required this.teamId,
    this.isExcluded = false,
    this.hasAnswered = false,
    this.isBanned = false,
  });

  final String teamId;
  final bool isExcluded;
  final bool hasAnswered;
  final bool isBanned;

  bool get canAnswer => !isExcluded && !hasAnswered && !isBanned;

  AnswerOrderEntry copyWith({
    String? teamId,
    bool? isExcluded,
    bool? hasAnswered,
    bool? isBanned,
  }) {
    return AnswerOrderEntry(
      teamId: teamId ?? this.teamId,
      isExcluded: isExcluded ?? this.isExcluded,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      isBanned: isBanned ?? this.isBanned,
    );
  }
}