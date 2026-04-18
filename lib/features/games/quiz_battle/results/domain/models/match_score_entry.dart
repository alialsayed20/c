class MatchScoreEntry {
  const MatchScoreEntry({
    required this.teamId,
    required this.baseScore,
    required this.finalScore,
    required this.isModified,
  });

  final String teamId;
  final int baseScore;
  final int finalScore;
  final bool isModified;
}