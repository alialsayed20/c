class Player {
  const Player({
    required this.id,
    required this.name,
    this.teamId,
    this.isExcluded = false,
    this.isEliminated = false,
  });

  final String id;
  final String name;
  final String? teamId;
  final bool isExcluded;
  final bool isEliminated;

  Player copyWith({
    String? id,
    String? name,
    String? teamId,
    bool? isExcluded,
    bool? isEliminated,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      teamId: teamId ?? this.teamId,
      isExcluded: isExcluded ?? this.isExcluded,
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }
}