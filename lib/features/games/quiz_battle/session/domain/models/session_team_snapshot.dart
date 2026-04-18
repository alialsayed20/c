class SessionTeamSnapshot {
  const SessionTeamSnapshot({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.playerIds,
    this.score = 0,
    this.isEliminated = false,
  });

  final String id;
  final String name;
  final int colorValue;
  final List<String> playerIds;
  final int score;
  final bool isEliminated;

  SessionTeamSnapshot copyWith({
    String? id,
    String? name,
    int? colorValue,
    List<String>? playerIds,
    int? score,
    bool? isEliminated,
  }) {
    return SessionTeamSnapshot(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      playerIds: playerIds ?? this.playerIds,
      score: score ?? this.score,
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }
}