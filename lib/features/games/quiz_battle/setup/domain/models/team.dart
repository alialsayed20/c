import 'player.dart';

class Team {
  const Team({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.playerIds,
  });

  final String id;
  final String name;
  final int colorValue;
  final List<String> playerIds;

  Team copyWith({
    String? id,
    String? name,
    int? colorValue,
    List<String>? playerIds,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      playerIds: playerIds ?? this.playerIds,
    );
  }

  List<Player> resolvePlayers(List<Player> allPlayers) {
    return allPlayers.where((Player p) => playerIds.contains(p.id)).toList();
  }
}