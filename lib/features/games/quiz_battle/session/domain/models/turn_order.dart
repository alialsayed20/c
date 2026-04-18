class TurnOrder {
  const TurnOrder({
    required this.teamIds,
    required this.currentIndex,
  });

  final List<String> teamIds;
  final int currentIndex;

  bool get isEmpty => teamIds.isEmpty;

  String? get currentTeamId {
    if (teamIds.isEmpty) {
      return null;
    }

    if (currentIndex < 0 || currentIndex >= teamIds.length) {
      return null;
    }

    return teamIds[currentIndex];
  }

  TurnOrder copyWith({
    List<String>? teamIds,
    int? currentIndex,
  }) {
    return TurnOrder(
      teamIds: teamIds ?? this.teamIds,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}