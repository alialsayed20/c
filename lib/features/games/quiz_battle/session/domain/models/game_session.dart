import '../enums/game_session_status.dart';
import 'session_player_snapshot.dart';
import 'session_team_snapshot.dart';
import 'turn_order.dart';

class GameSession {
  const GameSession({
    required this.id,
    required this.status,
    required this.teams,
    required this.players,
    required this.turnOrder,
    required this.createdAt,
  });

  final String id;
  final GameSessionStatus status;
  final List<SessionTeamSnapshot> teams;
  final List<SessionPlayerSnapshot> players;
  final TurnOrder turnOrder;
  final DateTime createdAt;

  String? get currentTeamId => turnOrder.currentTeamId;

  bool get isActive => status == GameSessionStatus.active;

  GameSession copyWith({
    String? id,
    GameSessionStatus? status,
    List<SessionTeamSnapshot>? teams,
    List<SessionPlayerSnapshot>? players,
    TurnOrder? turnOrder,
    DateTime? createdAt,
  }) {
    return GameSession(
      id: id ?? this.id,
      status: status ?? this.status,
      teams: teams ?? this.teams,
      players: players ?? this.players,
      turnOrder: turnOrder ?? this.turnOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}