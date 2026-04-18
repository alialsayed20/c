class SessionPlayerSnapshot {
  const SessionPlayerSnapshot({
    required this.id,
    required this.name,
    required this.teamId,
    this.isExcluded = false,
    this.isEliminated = false,
  });

  final String id;
  final String name;
  final String teamId;
  final bool isExcluded;
  final bool isEliminated;
}